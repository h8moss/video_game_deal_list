import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

class FilterSheetState {
  FilterSheetState({
    this.filterModel: const FilterModel(),
    this.sectionsExpansions: const {},
    this.allStores,
  }) : super();

  FilterSheetState updateWith({
    FilterModel? filterModel,
    Map<FilterSheetSections, bool>? sectionsExpansions,
    List<StoreModel>? allStores,
  }) {
    return FilterSheetState(
      allStores: allStores ?? this.allStores,
      filterModel: filterModel ?? this.filterModel,
      sectionsExpansions: sectionsExpansions ?? this.sectionsExpansions,
    );
  }

  /// current filter
  final FilterModel filterModel;

  /// current sections and weather they are expanded or not
  final Map<FilterSheetSections, bool> sectionsExpansions;

  /// List of all available stores
  final List<StoreModel>? allStores;

  /// List of all open available stores
  List<StoreModel> get activeStores {
    if (allStores != null)
      return allStores!.where((element) => element.isActive).toList();
    return [];
  }

  /// returns `true` if the [section] is expanded
  bool getSectionExpansion(FilterSheetSections section) {
    return sectionsExpansions[section] ?? false;
  }

  /// returns true if the [store] is selected
  bool isStoreSelected(StoreModel store) {
    return filterModel.stores.contains(store);
  }

  /// returns `true` if the [dealSorting] is descending, `false` if it is
  /// ascending and `null` if it is not selected
  bool? isSortDescending(DealSortingStyle dealSorting) {
    if (dealSorting == filterModel.sorting) return filterModel.isDescending;
  }
}

enum FilterSheetSections {
  PriceRange,
  Stores,
  Sorting,
  Rating,
  Other,
}
