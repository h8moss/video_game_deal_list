import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/app/deals/models/deal_results.dart';
import 'package:video_game_wish_list/app/filtering/filter_bottom_sheet.dart';
import 'package:video_game_wish_list/common/services/game_server.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(
    HomePageState initialState, {
    required this.server,
  }) : super(initialState) {
    add(GetInitialPageEvent());
  }

  final GameServer server;
  int _currentPage = 0;
  int _totalPages = 1;

  bool get hasMorePages => _currentPage < _totalPages - 1;

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is AppendDealsEvent)
      yield* _appendDeals(event);
    else if (event is SetDealsEvent)
      yield* _setDeals(event);
    else if (event is SetFilterEvent)
      yield* _setFilter(event);
    else if (event is GetInitialPageEvent)
      yield* _getInitialPage(event);
    else if (event is RenderItemEvent)
      yield* _renderItem(event);
    else if (event is FilterButtonPressedEvent)
      yield* _filterButtonPressed(event);
    else if (event is SetHasErrorEvent)
      yield* _setHasError(event);
    else if (event is RetryLoadingButtonEvent)
      yield* _retryLoadingButton(event);
    else
      throw UnimplementedError();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(SetHasErrorEvent(true));
    super.onError(error, stackTrace);
  }

  Stream<HomePageState> _appendDeals(AppendDealsEvent event) async* {
    if (state.deals != null) {
      yield state.updateWith(deals: [...state.deals!, ...event.deals]);
    } else
      yield state;
  }

  Stream<HomePageState> _setDeals(SetDealsEvent event) async* {
    yield state.updateWith(deals: event.deals);
  }

  Stream<HomePageState> _setFilter(SetFilterEvent event) async* {
    yield state.updateWith(filter: event.filter);
  }

  Stream<HomePageState> _getInitialPage(GetInitialPageEvent event) async* {
    _currentPage = 0;
    final deals = await _fetchGames();
    if (deals != null) {
      _totalPages = deals.totalPages;
      add(SetDealsEvent(deals.results));
    }
  }

  Stream<HomePageState> _renderItem(RenderItemEvent event) async* {
    int threshold = (_currentPage + 1) * 60 - 5;
    print(event.index);
    if (event.index > threshold && hasMorePages) {
      _currentPage++;
      final deals = await _fetchGames();
      if (deals != null) {
        _totalPages = deals.totalPages;
        add(AppendDealsEvent(deals.results));
      }
    }
  }

  Stream<HomePageState> _retryLoadingButton(
      RetryLoadingButtonEvent event) async* {
    final deals = await _fetchGames(_currentPage - 1);
    if (deals != null) {
      _totalPages = deals.totalPages;
      _currentPage++;
      add(AppendDealsEvent(deals.results));
    }
  }

  Stream<HomePageState> _filterButtonPressed(
      FilterButtonPressedEvent event) async* {
    final filter = await FilterBottomSheet.show(event.context, state.filter);
    if (filter != null) {
      add(SetDealsEvent(null));
      add(SetFilterEvent(filter));
      add(GetInitialPageEvent());
    }
  }

  Stream<HomePageState> _setHasError(SetHasErrorEvent event) async* {
    yield state.updateWith(hasError: event.value);
  }

  Future<DealResults?> _fetchGames([int? page]) async {
    if (page == null) page = _currentPage;
    add(SetHasErrorEvent(false));
    DealResults? games;
    try {
      games = await server.fetchGames(page, state.filter);
    } catch (e) {
      addError(e);
      return null;
    }
    return games;
  }
}
