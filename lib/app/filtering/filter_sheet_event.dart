import 'package:video_game_wish_list/app/filtering/filter_sheet_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';

class FilterSheetEvent {}

class ToggleUpperPriceRange extends FilterSheetEvent {}

class ToggleLowerPriceRange extends FilterSheetEvent {}

class SetLowerPriceRange extends FilterSheetEvent {
  SetLowerPriceRange(this.value);

  final int value;
}

class SetUpperPriceRange extends FilterSheetEvent {
  SetUpperPriceRange(this.value);

  final int value;
}

class ToggleExpandedPanel extends FilterSheetEvent {
  ToggleExpandedPanel(this.value);

  final FilterSheetSections value;
}

class SetExpandedPanel extends FilterSheetEvent {
  SetExpandedPanel(this.value, this.state);

  final FilterSheetSections value;
  final bool state;
}

class SetStoreSelection extends FilterSheetEvent {
  SetStoreSelection(this.value);

  StoreSelectionState value;
}

class SetStores extends FilterSheetEvent {
  SetStores(this.value);

  List<StoreModel> value;
}

class ToggleStoreValue extends FilterSheetEvent {
  ToggleStoreValue(this.store);

  StoreModel store;
}
