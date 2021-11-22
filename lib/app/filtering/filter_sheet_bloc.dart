import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';

import 'filter_sheet_event.dart';
import 'models/filter_sheet_state.dart';

class FilterSheetBloc extends Bloc<FilterSheetEvent, FilterSheetState> {
  FilterSheetBloc(FilterSheetState initialState, ApiDealServer server)
      : super(initialState) {
    server.getAllStores().then((value) {
      add(SetAllStores(value));

      on<SetExpandedPanel>((event, emit) => emit(_onSetExpandedPanel(event)));
      on<AddStore>((event, emit) => emit(_onAddStore(event)));
      on<RemoveStore>((event, emit) => emit(_onRemoveStore(event)));
      on<SetFilterValues>((event, emit) => emit(_onSetFilterValues(event)));
      on<SetAllStores>((event, emit) => emit(_onSetAllStores(event)));
      on<UpdateWithModel>((event, emit) => emit(_onUpdateWithModel(event)));
    });
  }

  FilterSheetState _onSetExpandedPanel(SetExpandedPanel event) {
    Map<FilterSheetSections, bool> newMap = Map.of(state.sectionsExpansions);
    newMap[event.value] = event.state;
    return state.updateWith(sectionsExpansions: newMap);
  }

  FilterSheetState _onAddStore(AddStore event) {
    var newStores = List.of(state.filterModel.stores);
    if (!newStores.contains(event.store)) newStores.add(event.store);
    return state.updateWith(
        filterModel: state.filterModel.updateWith(stores: newStores));
  }

  FilterSheetState _onRemoveStore(RemoveStore event) {
    var newStores = List.of(state.filterModel.stores);
    newStores.remove(event.store);
    return state.updateWith(
        filterModel: state.filterModel.updateWith(stores: newStores));
  }

  FilterSheetState _onSetFilterValues(SetFilterValues event) {
    bool descendingValue = state.filterModel.isDescending;
    if (event.sorting != null) {
      bool? currentDescending = state.isSortDescending(event.sorting!);
      if (currentDescending != true)
        descendingValue = true;
      else
        descendingValue = false;
    }
    return state.updateWith(
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

  FilterSheetState _onSetAllStores(SetAllStores event) {
    return state.updateWith(allStores: event.value);
  }

  FilterSheetState _onUpdateWithModel(UpdateWithModel event) {
    return state.updateWith(filterModel: event.model);
  }
}
