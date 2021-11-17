import 'package:equatable/equatable.dart';
import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

/// Information about a search filter
class FilterModel extends Equatable {
  const FilterModel({
    this.upperPrice: 49,
    this.lowerPrice: 0,
    this.stores: const [],
    this.sorting: DealSortingStyle.DealRating,
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

  /// maximum price of the deal, not of the game
  final int upperPrice;

  /// minimum price of the deal, not of the game
  final int lowerPrice;

  /// Accepted stores to search for
  final List<StoreModel> stores;

  /// Sort order
  final DealSortingStyle sorting;

  /// Weather the sort should be descending
  final bool isDescending;

  /// minimum score for a game on metacritic
  final int metacriticScore;

  /// minimum score for a game on steam
  final int steamScore;

  /// weather to ignore upperPrice
  final bool useUpperPrice;

  /// weather to ignore lowerPrice
  final bool useLowerPrice;

  /// weather to ignore metacritic score
  final bool useMetacriticScore;

  /// weather to ignore steamScore
  final bool useSteamScore;

  /// Weather to only display AAA games
  final bool isAAA;

  /// Weather to only display steam-redeemable games
  final bool steamWorks;

  /// Weather the deal is still active
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
