import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

class FilterSheetState {
  FilterSheetState({
    this.lowerPriceRange: 0,
    this.lowerPriceRangeIsAny: true,
    this.upperPriceRange: 49,
    this.upperPriceRangeIsAny: true,
    this.sectionsExpansions: const {},
    this.stores,
    this.storeSelections: const {},
    this.metacriticScore: 0,
    this.metacriticScoreIsAny: true,
    this.isDescending: true,
    this.sorting: DealSortingStyle.Rating,
    this.steamScore: 0,
    this.steamScoreIsAny: true,
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
        metacriticScore =
            filter.metacriticScore != null ? filter.metacriticScore! : 0,
        metacriticScoreIsAny = filter.metacriticScore == null,
        sorting = filter.sorting,
        isDescending = filter.isDescending,
        steamScore = filter.steamScore ?? 0,
        steamScoreIsAny = filter.steamScore == null,
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
    int? metacriticScore,
    bool? metacriticScoreIsAny,
    int? steamScore,
    bool? steamScoreIsAny,
    DealSortingStyle? sorting,
    bool? isDescending,
  }) {
    return FilterSheetState(
      lowerPriceRange: lowerPriceRange ?? this.lowerPriceRange,
      lowerPriceRangeIsAny: lowerPriceRangeIsAny ?? this.lowerPriceRangeIsAny,
      upperPriceRange: upperPriceRange ?? this.upperPriceRange,
      upperPriceRangeIsAny: upperPriceRangeIsAny ?? this.upperPriceRangeIsAny,
      sectionsExpansions: sectionsExpansions ?? this.sectionsExpansions,
      stores: stores ?? this.stores,
      storeSelections: storeSelections ?? this.storeSelections,
      metacriticScore: metacriticScore ?? this.metacriticScore,
      metacriticScoreIsAny: metacriticScoreIsAny ?? this.metacriticScoreIsAny,
      sorting: sorting ?? this.sorting,
      isDescending: isDescending ?? this.isDescending,
      steamScore: steamScore ?? this.steamScore,
      steamScoreIsAny: steamScoreIsAny ?? this.steamScoreIsAny,
    );
  }

  final bool lowerPriceRangeIsAny;
  final bool upperPriceRangeIsAny;

  final int lowerPriceRange;
  final int upperPriceRange;

  final Map<FilterSheetSections, bool> sectionsExpansions;

  final List<StoreModel>? stores;
  final Map<StoreModel, bool> storeSelections;

  final bool metacriticScoreIsAny;
  final int metacriticScore;

  final int steamScore;
  final bool steamScoreIsAny;

  final DealSortingStyle sorting;
  final bool isDescending;

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
    var selectedStores = Map.of(storeSelections)
      ..removeWhere((key, value) => !value);
    return FilterModel(
      lowerPrice: lowerPriceRangeIsAny ? null : lowerPriceRange,
      stores: selectedStores.keys.toList(),
      upperPrice: upperPriceRangeIsAny ? null : upperPriceRange,
      isDescending: isDescending,
      sorting: sorting,
      metacriticScore: metacriticScoreIsAny ? null : metacriticScore,
      steamScore: steamScoreIsAny ? null : steamScore,
    );
  }

  bool getSectionExpansion(FilterSheetSections section) {
    return sectionsExpansions[section] ?? false;
  }

  bool isStoreSelected(StoreModel store) {
    return storeSelections[store] ?? false;
  }

  bool? isSortDescending(DealSortingStyle dealSorting) {
    if (dealSorting == sorting) return isDescending;
  }
}

enum FilterSheetSections {
  PriceRange,
  Stores,
  Sorting,
  Rating,
  Other,
}
