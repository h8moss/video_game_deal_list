import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/models/store_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'filter_sheet_event.dart';
import 'filter_sheet_state.dart';

class FilterSheetBloc extends Bloc<FilterSheetEvent, FilterSheetState> {
  FilterSheetBloc(FilterSheetState initialState, GameServer server)
      : super(initialState) {
    server.getAllStores().then((value) {
      add(SetFilterValues(stores: value));
    });
  }

  @override
  Stream<FilterSheetState> mapEventToState(FilterSheetEvent event) async* {
    if (event is SetFilterValues)
      yield* _setFilterValues(event);
    else if (event is SetExpandedPanel)
      yield* _setExpandedPanel(event);
    else if (event is SetStoreSelection)
      yield* _setStoreSelection(event);
    else if (event is UpdateWithModel)
      yield FilterSheetState.fromFilter(event.model);
    else
      throw UnimplementedError();
  }

  Stream<FilterSheetState> _setExpandedPanel(SetExpandedPanel event) async* {
    Map<FilterSheetSections, bool> newMap = Map.of(state.sectionsExpansions);
    newMap[event.value] = event.state;
    yield state.updateWith(sectionsExpansions: newMap);
  }

  Stream<FilterSheetState> _setStoreSelection(SetStoreSelection event) async* {
    Map<StoreModel, bool> newMap = Map.of(state.storeSelections);
    newMap[event.value] = event.state;
    yield state.updateWith(storeSelections: newMap);
  }

  Stream<FilterSheetState> _setFilterValues(SetFilterValues event) async* {
    bool descendingValue = state.isDescending;
    if (event.sort != null) {
      bool? currentDescending = state.isSortDescending(event.sort!);
      if (currentDescending != true)
        descendingValue = true;
      else
        descendingValue = false;
    }
    yield state.updateWith(
      lowerPriceRange: event.lowerPriceRange,
      metacriticScore: event.metacriticScore,
      lowerPriceRangeIsAny: event.lowerPriceRangeIsAny,
      metacriticScoreIsAny: event.metacriticScoreIsAny,
      sorting: event.sort,
      steamScore: event.steamScore,
      steamScoreIsAny: event.steamScoreIsAny,
      storeSelections: event.storeValues,
      stores: event.stores,
      upperPriceRange: event.upperPriceRange,
      upperPriceRangeIsAny: event.upperPriceRangeIsAny,
      isDescending: descendingValue,
    );
  }

  String filterSheetSectionsNames(FilterSheetSections section) {
    switch (section) {
      case FilterSheetSections.PriceRange:
        return 'Price range';
      case FilterSheetSections.Rating:
        return 'Rating';
      case FilterSheetSections.Sorting:
        return 'Sorting';
      case FilterSheetSections.Stores:
        return 'Stores';
      case FilterSheetSections.Other:
        return 'Other';
    }
  }

  String dealSortingNames(DealSortingStyle sorting) {
    switch (sorting) {
      case DealSortingStyle.Rating:
        return 'Deal rating';
      case DealSortingStyle.Title:
        return 'Title';
      case DealSortingStyle.Savings:
        return 'Savings';
      case DealSortingStyle.Price:
        return 'Price';
      case DealSortingStyle.Metacritic:
        return 'Metacritic score';
      case DealSortingStyle.Reviews:
        return 'Reviews';
      case DealSortingStyle.Release:
        return 'Release date';
      case DealSortingStyle.Store:
        return 'Store';
      case DealSortingStyle.Recent:
        return 'Recent';
    }
  }
}
