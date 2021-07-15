import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_game_wish_list/app/filtering/filter_bottom_sheet.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'home_page_event.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(
    HomePageState initialState, {
    required this.server,
  }) : super(initialState) {
    getPage0();
  }

  final GameServer server;
  int currentPage = 0;
  int totalPages = 1;

  bool get hasMorePages => currentPage < totalPages - 1;

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if (event is AppendDealsEvent)
      yield state.updateWith(deals: [...state.deals, ...event.deals]);
    if (event is SetDealsEvent)
      yield state.updateWith(deals: event.deals);
    else
      throw UnimplementedError();
  }

  void onRender(int i) async {
    int threshold = (currentPage + 1) * 60 - 5;
    print('rendering $i');
    if (i >= threshold) {
      print('Past threshold!');
      if (hasMorePages) {
        currentPage++;
        final items = await server.fetchGames(currentPage);
        totalPages = items.totalPages;
        add(AppendDealsEvent(items.results));
      }
    }
  }

  Future<void> getPage0() async {
    final page0 = await server.fetchGames(0);
    currentPage = 0;
    totalPages = page0.totalPages;
    add(SetDealsEvent(page0.results));
  }

  Future<void> onFiltering(BuildContext context) async {
    final filter = await FilterBottomSheet.show(context, state.filter);
  }
}

class HomePageState {
  HomePageState({
    this.deals: const [],
    this.filter: const FilterModel(),
  });

  final List<DealModel> deals;
  final FilterModel filter;

  HomePageState updateWith({
    List<DealModel>? deals,
    FilterModel? filter,
  }) {
    return HomePageState(
      deals: deals ?? this.deals,
      filter: filter ?? this.filter,
    );
  }

  int get dealCount => deals.length;
}
