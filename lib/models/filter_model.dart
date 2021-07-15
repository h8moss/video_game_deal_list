import 'package:video_game_wish_list/models/store_model.dart';

class FilterModel {
  const FilterModel({
    this.upperPrice,
    this.lowerPrice,
    this.stores: const [],
    this.sorting: DealSorting.Rating,
    this.isDescending: false,
    this.metaCriticScore,
    this.steamScore,
  });

  final int? upperPrice;
  final int? lowerPrice;
  final List<StoreModel> stores;
  final DealSorting sorting;
  final bool isDescending;
  final int? metaCriticScore;
  final int? steamScore;
}

enum DealSorting {
  Rating, // default
  Title,
  Savings,
  Price,
  MetaCritic,
  Reviews,
  Release,
  Store,
  Recent,
}
