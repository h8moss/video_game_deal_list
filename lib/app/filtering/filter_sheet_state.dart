import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';

class FilterSheetState {
  FilterSheetState({
    this.lowerPriceRange: 0,
    this.lowerPriceRangeIsAny: true,
    this.upperPriceRange: 49,
    this.upperPriceRangeIsAny: true,
    this.sectionsExpansions: const {},
    this.stores,
    this.storeSelections: const {},
  });

  FilterSheetState.fromFilter(FilterModel filter)
      : lowerPriceRange = filter.lowerPrice ?? 0,
        lowerPriceRangeIsAny = filter.lowerPrice == null,
        sectionsExpansions = const {},
        storeSelections = Map.unmodifiable(filter.stores
            .fold<Map<StoreModel, bool>>(
                {},
                (previousValue, element) =>
                    previousValue..addAll({element: true}))),
        stores = null,
        upperPriceRange = filter.upperPrice ?? 0,
        upperPriceRangeIsAny = filter.upperPrice == null;

  FilterSheetState updateWith({
    bool? lowerPriceRangeIsAny,
    bool? upperPriceRangeIsAny,
    int? lowerPriceRange,
    int? upperPriceRange,
    FilterModel? filterModel,
    Map<FilterSheetSections, bool>? sectionsExpansions,
    List<StoreModel>? stores,
    Map<StoreModel, bool>? storeSelections,
  }) {
    return FilterSheetState(
      lowerPriceRange: lowerPriceRange ?? this.lowerPriceRange,
      lowerPriceRangeIsAny: lowerPriceRangeIsAny ?? this.lowerPriceRangeIsAny,
      upperPriceRange: upperPriceRange ?? this.upperPriceRange,
      upperPriceRangeIsAny: upperPriceRangeIsAny ?? this.upperPriceRangeIsAny,
      sectionsExpansions: sectionsExpansions ?? this.sectionsExpansions,
      stores: stores ?? this.stores,
      storeSelections: storeSelections ?? this.storeSelections,
    );
  }

  final bool lowerPriceRangeIsAny;
  final bool upperPriceRangeIsAny;

  final int lowerPriceRange;
  final int upperPriceRange;

  final Map<FilterSheetSections, bool> sectionsExpansions;

  final List<StoreModel>? stores;
  final Map<StoreModel, bool> storeSelections;

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

  Map<StoreModel, bool> get allStores {
    if (stores != null) {
      return stores!.fold(
        {},
        (previousValue, element) => previousValue..addAll({element: true}),
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
    return storeSelections[store] ?? false;
  }
}

enum FilterSheetSections {
  PriceRange,
  Stores,
  Sorting,
  Rating,
}
