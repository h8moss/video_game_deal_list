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

class SetStoreSelection extends FilterSheetEvent {
  SetStoreSelection(this.value, this.state);

  final StoreModel value;
  final bool state;
}

class SetFilterValues extends FilterSheetEvent {
  SetFilterValues({
    this.sort,
    this.storeValues,
    this.stores,
    this.upperPriceRange,
    this.lowerPriceRange,
    this.upperPriceRangeIsAny,
    this.lowerPriceRangeIsAny,
    this.metacriticScore,
    this.steamScore,
    this.metacriticScoreIsAny,
    this.steamScoreIsAny,
  });

  final DealSortingStyle? sort;
  final Map<StoreModel, bool>? storeValues;
  final List<StoreModel>? stores;
  final int? upperPriceRange;
  final int? lowerPriceRange;
  final bool? upperPriceRangeIsAny;
  final bool? lowerPriceRangeIsAny;
  final int? metacriticScore;
  final int? steamScore;
  final bool? metacriticScoreIsAny;
  final bool? steamScoreIsAny;
}
