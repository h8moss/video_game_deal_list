import 'package:video_game_wish_list/common/other/double_extension.dart';

/// Video game deal Representation
class DealModel {
  const DealModel({
    required this.gameName,
    required this.price,
    required this.originalPrice,
    required this.thumbnailUrl,
    required this.storeId,
    required this.percentageOff,
    required this.id,
    required this.cheapestDeal,
    required this.cheapestPrice,
  });
  factory DealModel.fromJson(dynamic json) {
    return DealModel(
      gameName: json['title']!,
      originalPrice: double.parse(json['normalPrice']!),
      price: double.parse(json['salePrice']!),
      thumbnailUrl: json['thumb']!,
      storeId: int.parse(json['storeID']!),
      percentageOff: double.parse(json['savings']!),
      id: json['dealID'],
      cheapestDeal: null,
      cheapestPrice: -1,
    );
  }

  factory DealModel.fromGameInfoJson(dynamic json, String dealId,
      [String? cheapestDeal, double cheapestPrice = -1]) {
    double retail = double.parse(json['gameInfo']['retailPrice']);
    double sale = double.parse(json['gameInfo']['salePrice']);
    return DealModel(
      gameName: json['gameInfo']['name'],
      id: dealId,
      originalPrice: retail,
      percentageOff: 100 - (100 * sale / retail),
      price: sale,
      storeId: int.parse(json['gameInfo']['storeID']),
      thumbnailUrl: json['gameInfo']['thumb'],
      cheapestDeal: cheapestDeal,
      cheapestPrice: cheapestDeal != null ? cheapestPrice : -1,
    );
  }

  String description() {
    String priceString = 'only $price\$';
    if (isFree) priceString = 'free!';
    return "$gameName is $priceString, that's a $formattedPercentageOff% off";
  }

  /// Unique deal id
  final String id;

  /// readable name of the game
  final String gameName;

  /// URL to video game image
  final String thumbnailUrl;

  /// current price with deal
  final double price;

  /// original video game price
  final double originalPrice;

  /// store in which deal is
  final int storeId;

  /// sale represented as a number from 0 to 100
  final double percentageOff;

  /// cheapest deal ID if any
  final String? cheapestDeal;

  /// cheapest available price
  final double cheapestPrice;

  /// true only if price is 0
  bool get isFree => price == 0;

  /// true if there is a cheaper deal for the game
  bool get hasBetterDeal =>
      cheapestDeal != null && cheapestDeal != id && cheapestPrice < price;

  /// rounded and formatted percentage value
  ///
  /// | actual     | formatted |
  /// |:-----------|----------:|
  /// | 99.999999  | 99.99     |
  /// | 100.00     | 100       |
  /// | 73.00001   | 73        |
  String get formattedPercentageOff => percentageOff.toStringAsDynamic(2);
}
