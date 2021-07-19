import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_game_wish_list/app/filtering/filter_bottom_sheet.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(
    HomePageState initialState, {
    required this.server,
  }) : super(initialState) {
    _getPage0();
  }

  final GameServer server;
  int _currentPage = 0;
  int _totalPages = 1;

  bool get hasMorePages => _currentPage < _totalPages - 1;

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is AppendDealsEvent)
      yield state.updateWith(deals: [...state.deals ?? [], ...event.deals]);
    else if (event is SetDealsEvent)
      yield state.updateWith(deals: event.deals);
    else if (event is SetFilterEvent) {
      yield state.updateWith(filter: event.filter);
      add(GetInitialPageEvent());
    } else if (event is GetInitialPageEvent) {
      add(SetDealsEvent(null));
      await _getPage0();
    } else if (event is RenderItemEvent)
      _onRender(event.index);
    else if (event is FilterButtonPressedEvent)
      _onFiltering(event.context);
    else
      throw UnimplementedError();
  }

  void _onRender(int i) async {
    int threshold = (_currentPage + 1) * 60 - 5;
    print('rendering $i');
    if (i >= threshold) {
      print('Past threshold!');
      if (hasMorePages) {
        _currentPage++;
        final items = await server.fetchGames(_currentPage, state.filter);
        _totalPages = items.totalPages;
        add(AppendDealsEvent(items.results));
      }
    }
  }

  Future<void> _getPage0() async {
    final page0 = await server.fetchGames(0, state.filter);
    _currentPage = 0;
    _totalPages = page0.totalPages;
    add(SetDealsEvent(page0.results));
  }

  Future<void> _onFiltering(BuildContext context) async {
    final filter = await FilterBottomSheet.show(context, state.filter);
    if (filter != null) {
      add(SetFilterEvent(filter));
    }
  }
}
