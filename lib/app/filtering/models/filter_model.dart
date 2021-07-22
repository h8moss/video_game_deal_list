import 'package:equatable/equatable.dart';
import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

class FilterModel extends Equatable {
  const FilterModel({
    this.upperPrice: 49,
    this.lowerPrice: 0,
    this.stores: const [],
    this.sorting: DealSortingStyle.Rating,
    this.isDescending: true,
    this.metacriticScore: 0,
    this.steamScore: 0,
    this.useLowerPrice: false,
    this.useMetacriticScore: false,
    this.useSteamScore: false,
    this.useUpperPrice: false,
    this.isAAA: false,
    this.isActive: true,
    this.steamWorks: false,
  });

  FilterModel updateWith({
    int? upperPrice,
    int? lowerPrice,
    List<StoreModel>? stores,
    DealSortingStyle? sorting,
    bool? isDescending,
    int? metacriticScore,
    int? steamScore,
    bool? useUpperPrice,
    bool? useLowerPrice,
    bool? useMetacriticScore,
    bool? useSteamScore,
    bool? isAAA,
    bool? isActive,
    bool? steamWorks,
  }) {
    return FilterModel(
      isDescending: isDescending ?? this.isDescending,
      lowerPrice: lowerPrice ?? this.lowerPrice,
      metacriticScore: metacriticScore ?? this.metacriticScore,
      sorting: sorting ?? this.sorting,
      steamScore: steamScore ?? this.steamScore,
      stores: stores ?? this.stores,
      upperPrice: upperPrice ?? this.upperPrice,
      useLowerPrice: useLowerPrice ?? this.useLowerPrice,
      useMetacriticScore: useMetacriticScore ?? this.useMetacriticScore,
      useSteamScore: useSteamScore ?? this.useSteamScore,
      useUpperPrice: useUpperPrice ?? this.useUpperPrice,
      isAAA: isAAA ?? this.isAAA,
      isActive: isActive ?? this.isActive,
      steamWorks: steamWorks ?? this.steamWorks,
    );
  }

  final int upperPrice;
  final int lowerPrice;
  final List<StoreModel> stores;
  final DealSortingStyle sorting;
  final bool isDescending;
  final int metacriticScore;
  final int steamScore;

  final bool useUpperPrice;
  final bool useLowerPrice;
  final bool useMetacriticScore;
  final bool useSteamScore;

  final bool isAAA;
  final bool steamWorks;
  final bool isActive;

  bool get isDefault => FilterModel() == this;

  @override
  List<Object?> get props => [
        upperPrice,
        lowerPrice,
        stores,
        sorting,
        isDescending,
        metacriticScore,
        steamScore,
        useLowerPrice,
        useMetacriticScore,
        useSteamScore,
        useUpperPrice,
        isAAA,
        isActive,
        steamWorks,
      ];
}
