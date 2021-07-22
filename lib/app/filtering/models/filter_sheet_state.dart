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

  final FilterModel filterModel;
  final Map<FilterSheetSections, bool> sectionsExpansions;
  final List<StoreModel>? allStores;

  List<StoreModel> get activeStores {
    if (allStores != null)
      return allStores!.where((element) => element.isActive).toList();
    return [];
  }

  bool getSectionExpansion(FilterSheetSections section) {
    return sectionsExpansions[section] ?? false;
  }

  bool isStoreSelected(StoreModel store) {
    return filterModel.stores.contains(store);
  }

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
