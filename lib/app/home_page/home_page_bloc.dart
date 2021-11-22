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
    on<AppendDeals>((event, emit) => emit(_onAppendDeals(event)));
    on<SetDeals>((event, emit) => emit(_onSetDeals(event)));
    on<SetFilter>((event, emit) => emit(_onSetFilter(event)));
    on<GetInitialPage>((event, emit) async => await _onGetInitialPage(event));
    on<RenderItem>((event, emit) async => await _onRenderItem(event));
    on<RetryLoadingButton>(
        (event, emit) async => await _onRetryLoadingButton(event));
    on<FilterButtonPressed>(
        (event, emit) async => await _onFilterButtonPressed(event));
    on<SetHasError>((event, emit) => emit(_onSetHasError(event)));
    on<SetIsSearching>((event, emit) => emit(_onSetIsSearching(event)));
    on<UpdateSearchTerm>((event, emit) => _onUpdateSearchTerm(event));
    on<SetSearchTerm>((event, emit) => emit(_onSetSearchTerm(event)));
    on<SetBottomNavigation>((event, emit) => _onSetBottomNavigation(event));

    add(GetInitialPage());
  }

  final List<DealServer> servers;

  int serverIndex = 0;
  int _currentPage = 0;
  int _totalPages = 1;

  bool get hasMorePages => _currentPage < _totalPages - 1;

  DealServer get selectedServer => servers[serverIndex];

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(SetHasError(true));
    super.onError(error, stackTrace);
  }

  HomePageState _onAppendDeals(AppendDeals event) {
    if (state.deals != null) {
      return state.updateWith(deals: [...state.deals!, ...event.deals]);
    } else
      return state;
  }

  HomePageState _onSetDeals(SetDeals event) {
    return state.updateWith(deals: event.deals);
  }

  HomePageState _onSetFilter(SetFilter event) {
    return state.updateWith(filter: event.filter);
  }

  Future<void> _onGetInitialPage(GetInitialPage event) async {
    _currentPage = 0;
    final deals = await _fetchDeals();
    if (deals != null) {
      _totalPages = deals.totalPages;
      add(SetDeals(deals.results));
    }
  }

  Future<void> _onRenderItem(RenderItem event) async {
    int threshold = (_currentPage + 1) * 60 - 5;

    if (event.index > threshold && hasMorePages) {
      _currentPage++;
      final deals = await _fetchDeals();
      if (deals != null) {
        _totalPages = deals.totalPages;
        add(AppendDeals(deals.results));
      }
    }
  }

  Future<void> _onRetryLoadingButton(RetryLoadingButton event) async {
    final deals = await _fetchDeals(_currentPage - 1);
    if (deals != null) {
      _totalPages = deals.totalPages;
      _currentPage++;
      add(AppendDeals(deals.results));
    }
  }

  Future<void> _onFilterButtonPressed(FilterButtonPressed event) async {
    final filter = await FilterBottomSheet.show(event.context, state.filter);
    if (filter != null) {
      add(SetDeals(null));
      add(SetFilter(filter));
      add(GetInitialPage());
    }
  }

  HomePageState _onSetHasError(SetHasError event) {
    return state.updateWith(hasError: event.value);
  }

  HomePageState _onSetIsSearching(SetIsSearching event) {
    if (!event.value) add(SetSearchTerm(''));
    return state.updateWith(isSearching: event.value);
  }

  void _onUpdateSearchTerm(UpdateSearchTerm event) {
    add(SetDeals(null));
    add(SetSearchTerm(event.value));
    add(GetInitialPage());
  }

  HomePageState _onSetSearchTerm(SetSearchTerm event) {
    return state.updateWith(searchTerm: event.value);
  }

  void _onSetBottomNavigation(SetBottomNavigation event) {
    if (event.value < servers.length) {
      serverIndex = event.value;
      add(SetDeals(null));
      add(GetInitialPage());
    }
  }

  Future<DealResults?> _fetchDeals([int? page]) async {
    if (page == null) page = _currentPage;
    add(SetHasError(false));
    DealResults? games;
    await selectedServer.initialize();
    try {
      games =
          await selectedServer.fetchDeals(page, state.filter, state.searchTerm);
    } catch (e) {
      addError(e);
      return null;
    }
    return games;
  }

  @override
  Future<void> close() async {
    for (var server in servers) {
      server.dispose();
    }
    super.close();
  }
}
