import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/app/deals/models/deal_results.dart';
import 'package:video_game_wish_list/app/filtering/filter_bottom_sheet.dart';
import 'package:video_game_wish_list/common/services/deal_server.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(
    HomePageState initialState, {
    required this.servers,
  }) : super(initialState) {
    add(GetInitialPageEvent());
  }

  final List<DealServer> servers;

  int serverIndex = 0;

  int _currentPage = 0;
  int _totalPages = 1;

  bool get hasMorePages => _currentPage < _totalPages - 1;

  DealServer get selectedServer => servers[serverIndex];

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
    else if (event is SetIsSearchingEvent)
      yield* _setIsSearching(event);
    else if (event is SetSearchTermEvent)
      yield* _setSearchTerm(event);
    else if (event is SetBottomNavigationEvent)
      yield* _setBottomNavigation(event);
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
    final deals = await _fetchDeals();
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
      final deals = await _fetchDeals();
      if (deals != null) {
        _totalPages = deals.totalPages;
        add(AppendDealsEvent(deals.results));
      }
    }
  }

  Stream<HomePageState> _retryLoadingButton(
      RetryLoadingButtonEvent event) async* {
    final deals = await _fetchDeals(_currentPage - 1);
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

  Stream<HomePageState> _setIsSearching(SetIsSearchingEvent event) async* {
    yield state.updateWith(isSearching: event.value);
    if (!event.value) add(SetSearchTermEvent(''));
  }

  Stream<HomePageState> _setSearchTerm(SetSearchTermEvent event) async* {
    yield state.updateWith(searchTerm: event.value);
    add(GetInitialPageEvent());
  }

  Stream<HomePageState> _setBottomNavigation(
      SetBottomNavigationEvent event) async* {
    if (event.value < servers.length) {
      serverIndex = event.value;
      add(SetDealsEvent(null));
      add(GetInitialPageEvent());
    }
  }

  Future<DealResults?> _fetchDeals([int? page]) async {
    if (page == null) page = _currentPage;
    add(SetHasErrorEvent(false));
    DealResults? games;
    try {
      games =
          await selectedServer.fetchDeals(page, state.filter, state.searchTerm);
    } catch (e) {
      addError(e);
      return null;
    }
    return games;
  }
}
