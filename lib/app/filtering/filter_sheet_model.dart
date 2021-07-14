import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';

class FilterSheetModel {
  FilterSheetModel({
    this.lowerPriceRange: 0,
    this.lowerPriceRangeIsAny: true,
    this.upperPriceRange: 49,
    this.upperPriceRangeIsAny: true,
    this.sectionsExpansions: const {},
    this.stores,
    this.storeSelections: const {},
    StoreSelectionState storeSelectionState: StoreSelectionState.Any,
  }) : _storeSelectionState = storeSelectionState;

  FilterSheetModel updateWith({
    bool? lowerPriceRangeIsAny,
    bool? upperPriceRangeIsAny,
    int? lowerPriceRange,
    int? upperPriceRange,
    FilterModel? filterModel,
    Map<FilterSheetSections, bool>? sectionsExpansions,
    StoreSelectionState? storeSelectionState,
    List<StoreModel>? stores,
    Map<StoreModel, bool>? storeSelections,
  }) {
    return FilterSheetModel(
      lowerPriceRange: lowerPriceRange ?? this.lowerPriceRange,
      lowerPriceRangeIsAny: lowerPriceRangeIsAny ?? this.lowerPriceRangeIsAny,
      upperPriceRange: upperPriceRange ?? this.upperPriceRange,
      upperPriceRangeIsAny: upperPriceRangeIsAny ?? this.upperPriceRangeIsAny,
      sectionsExpansions: sectionsExpansions ?? this.sectionsExpansions,
      storeSelectionState: storeSelectionState ?? _storeSelectionState,
      stores: stores ?? this.stores,
      storeSelections: storeSelections ?? this.storeSelections,
    );
  }

  final bool lowerPriceRangeIsAny;
  final bool upperPriceRangeIsAny;

  final int lowerPriceRange;
  final int upperPriceRange;

  final Map<FilterSheetSections, bool> sectionsExpansions;
  final StoreSelectionState _storeSelectionState;

  final List<StoreModel>? stores;
  final Map<StoreModel, bool> storeSelections;

  bool get storeSelectionIsAny =>
      _storeSelectionState == StoreSelectionState.Any;

  bool get storeSelectionIsSelected =>
      _storeSelectionState == StoreSelectionState.Selected;

  bool get storeSelectionIsActive =>
      _storeSelectionState == StoreSelectionState.Active;

  Map<StoreModel, bool> get activeStores {
    if (stores != null) {
      return stores!.fold(
        <StoreModel, bool>{},
        (previousValue, element) =>
            previousValue..addAll({element: element.isActive}),
      );
    }
    return {};
  }

  FilterModel get filterModel {
    // TODO: Implement this
    return FilterModel();
  }

  bool getSectionExpansion(FilterSheetSections section) {
    return sectionsExpansions[section] ?? false;
  }

  bool isStoreSelected(StoreModel store) {
    return storeSelections[store] ?? true;
  }
}

enum FilterSheetSections {
  PriceRange,
  Stores,
  Sorting,
  Rating,
}

enum StoreSelectionState {
  Any,
  Selected,
  Active,
}
