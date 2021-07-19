import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:video_game_wish_list/models/store_model.dart';

import 'deal_sorting_Style.dart';

class FilterModel {
  const FilterModel({
    this.upperPrice,
    this.lowerPrice,
    this.stores: const [],
    this.sorting: DealSortingStyle.Rating,
    this.isDescending: true,
    this.metacriticScore,
    this.steamScore,
  });

  FilterModel updateWith(
      {int? upperPrice,
      int? lowerPrice,
      List<StoreModel>? stores,
      DealSortingStyle? sorting,
      bool? isDescending,
      int? metacriticScore,
      int? steamScore}) {
    return FilterModel(
      isDescending: isDescending ?? this.isDescending,
      lowerPrice: lowerPrice ?? this.lowerPrice,
      metacriticScore: metacriticScore ?? this.metacriticScore,
      sorting: sorting ?? this.sorting,
      steamScore: steamScore ?? this.steamScore,
      stores: stores ?? this.stores,
      upperPrice: upperPrice ?? this.upperPrice,
    );
  }

  final int? upperPrice;
  final int? lowerPrice;
  final List<StoreModel> stores;
  final DealSortingStyle sorting;
  final bool isDescending;
  final int? metacriticScore;
  final int? steamScore;

  bool get isDefault => FilterModel() == this;

  @override
  operator ==(dynamic other) {
    return (other != null &&
        other is FilterModel &&
        other.isDescending == isDescending &&
        other.lowerPrice == lowerPrice &&
        other.metacriticScore == metacriticScore &&
        other.sorting == sorting &&
        other.steamScore == steamScore &&
        listEquals(other.stores, stores) &&
        other.upperPrice == upperPrice);
  }

  @override
  int get hashCode => hashValues(
        isDescending,
        lowerPrice,
        metacriticScore,
        sorting,
        steamScore,
        hashList(stores),
        upperPrice,
      );
}
