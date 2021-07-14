import 'package:bloc/bloc.dart';
import 'package:video_game_wish_list/models/store_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'filter_sheet_event.dart';
import 'filter_sheet_model.dart';

class FilterSheetBloc extends Bloc<FilterSheetEvent, FilterSheetModel> {
  FilterSheetBloc(FilterSheetModel initialState, GameServer server)
      : super(initialState) {
    server.getAllStores().then((value) {
      if (value != null) add(SetStores(value));
    });
  }

  @override
  Stream<FilterSheetModel> mapEventToState(FilterSheetEvent event) async* {
    if (event is ToggleLowerPriceRange)
      yield state.updateWith(lowerPriceRangeIsAny: !state.lowerPriceRangeIsAny);
    else if (event is ToggleUpperPriceRange)
      yield state.updateWith(upperPriceRangeIsAny: !state.upperPriceRangeIsAny);
    else if (event is SetLowerPriceRange)
      yield state.updateWith(lowerPriceRange: event.value);
    else if (event is SetUpperPriceRange)
      yield state.updateWith(upperPriceRange: event.value);
    else if (event is ToggleExpandedPanel)
      yield _setExpandedPanel(
          event.value, !state.getSectionExpansion(event.value));
    else if (event is SetExpandedPanel)
      yield _setExpandedPanel(event.value, event.state);
    else if (event is SetStoreSelection) {
      Map<StoreModel, bool> storesValue = state.storeSelections;
      if (event.value == StoreSelectionState.Active)
        storesValue = state.activeStores;
      yield state.updateWith(
          storeSelectionState: event.value, storeSelections: storesValue);
    } else if (event is SetStores)
      yield state.updateWith(stores: event.value);
    else if (event is ToggleStoreValue) {
      if (state.stores != null) {
        yield _setStoreSelection(
            event.store, !state.isStoreSelected(event.store));
      }
    } else
      throw UnimplementedError();
  }

  FilterSheetModel _setExpandedPanel(FilterSheetSections section, bool value) {
    Map<FilterSheetSections, bool> newMap = Map.of(state.sectionsExpansions);
    newMap[section] = value;
    return state.updateWith(sectionsExpansions: newMap);
  }

  FilterSheetModel _setStoreSelection(StoreModel store, bool value) {
    Map<StoreModel, bool> newMap = Map.of(state.storeSelections);
    newMap[store] = value;
    return state.updateWith(storeSelections: newMap);
  }
}
