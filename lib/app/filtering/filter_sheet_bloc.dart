import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';

import 'filter_sheet_event.dart';
import 'models/filter_sheet_state.dart';

class FilterSheetBloc extends Bloc<FilterSheetEvent, FilterSheetState> {
  FilterSheetBloc(FilterSheetState initialState, ApiDealServer server)
      : super(initialState) {
    server.getAllStores().then((value) {
      add(SetAllStores(value));
    });
  }

  @override
  Stream<FilterSheetState> mapEventToState(FilterSheetEvent event) async* {
    if (event is SetFilterValues)
      yield* _setFilterValues(event);
    else if (event is SetExpandedPanel)
      yield* _setExpandedPanel(event);
    else if (event is AddStore)
      yield* _addStore(event);
    else if (event is SetAllStores)
      yield* _setAllStores(event);
    else if (event is RemoveStore)
      yield* _removeStore(event);
    else if (event is UpdateWithModel)
      yield* _updateWithModel(event);
    else
      throw UnimplementedError();
  }

  Stream<FilterSheetState> _setExpandedPanel(SetExpandedPanel event) async* {
    Map<FilterSheetSections, bool> newMap = Map.of(state.sectionsExpansions);
    newMap[event.value] = event.state;
    yield state.updateWith(sectionsExpansions: newMap);
  }

  Stream<FilterSheetState> _addStore(AddStore event) async* {
    var newStores = List.of(state.filterModel.stores);
    if (!newStores.contains(event.store)) newStores.add(event.store);
    yield state.updateWith(
        filterModel: state.filterModel.updateWith(stores: newStores));
  }

  Stream<FilterSheetState> _removeStore(RemoveStore event) async* {
    var newStores = List.of(state.filterModel.stores);
    newStores.remove(event.store);
    yield state.updateWith(
        filterModel: state.filterModel.updateWith(stores: newStores));
  }

  Stream<FilterSheetState> _setFilterValues(SetFilterValues event) async* {
    bool descendingValue = state.filterModel.isDescending;
    if (event.sorting != null) {
      bool? currentDescending = state.isSortDescending(event.sorting!);
      if (currentDescending != true)
        descendingValue = true;
      else
        descendingValue = false;
    }
    yield state.updateWith(
      filterModel: state.filterModel.updateWith(
        lowerPrice: event.lowerPrice,
        metacriticScore: event.metacriticScore,
        useLowerPrice: event.useLowerPrice,
        useMetacriticScore: event.useMetacriticScore,
        sorting: event.sorting,
        steamScore: event.steamScore,
        useSteamScore: event.useSteamScore,
        stores: event.stores,
        upperPrice: event.upperPrice,
        useUpperPrice: event.useUpperPrice,
        isDescending: descendingValue,
        isAAA: event.isAAA,
        isActive: event.isActive,
        steamWorks: event.steamWorks,
      ),
    );
  }

  Stream<FilterSheetState> _setAllStores(SetAllStores event) async* {
    yield state.updateWith(allStores: event.value);
  }

  Stream<FilterSheetState> _updateWithModel(UpdateWithModel event) async* {
    yield state.updateWith(filterModel: event.model);
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
