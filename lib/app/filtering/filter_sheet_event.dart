import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_sheet_state.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

class FilterSheetEvent {}

class SetExpandedPanel extends FilterSheetEvent {
  SetExpandedPanel(this.value, this.state);

  final FilterSheetSections value;
  final bool state;
}

class UpdateWithModel extends FilterSheetEvent {
  UpdateWithModel(this.model);

  FilterModel model;
}

class AddStore extends FilterSheetEvent {
  AddStore(this.store);
  StoreModel store;
}

class RemoveStore extends FilterSheetEvent {
  RemoveStore(this.store);

  StoreModel store;
}

class SetFilterValues extends FilterSheetEvent {
  SetFilterValues({
    this.sorting,
    this.upperPrice,
    this.lowerPrice,
    this.useUpperPrice,
    this.useLowerPrice,
    this.metacriticScore,
    this.steamScore,
    this.useMetacriticScore,
    this.useSteamScore,
    this.stores,
    this.isAAA,
    this.isActive,
    this.steamWorks,
  });

  final DealSortingStyle? sorting;
  final List<StoreModel>? stores;
  final int? upperPrice;
  final int? lowerPrice;
  final bool? useUpperPrice;
  final bool? useLowerPrice;
  final int? metacriticScore;
  final int? steamScore;
  final bool? useMetacriticScore;
  final bool? useSteamScore;
  final bool? isActive;
  final bool? isAAA;
  final bool? steamWorks;
}

class SetAllStores extends FilterSheetEvent {
  SetAllStores(this.value);

  List<StoreModel>? value;
}
