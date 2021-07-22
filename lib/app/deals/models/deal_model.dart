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
  });
  factory DealModel.fromJson(dynamic json) {
    return DealModel(
        gameName: json['title']!,
        originalPrice: double.parse(json['normalPrice']!),
        price: double.parse(json['salePrice']!),
        thumbnailUrl: json['thumb']!,
        storeId: int.parse(json['storeID']!),
        percentageOff: double.parse(json['savings']!),
        id: json['dealID']);
  }

  factory DealModel.fromGameInfoJson(dynamic json, String dealId) {
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
    );
  }

  final String id;
  final String gameName;
  final String thumbnailUrl;
  final double price;
  final double originalPrice;
  final int storeId;
  final double percentageOff;

  bool get isFree => price == 0;

  String get formattedPercentageOff => percentageOff.toStringAsDynamic(2);
}
