import 'package:video_game_wish_list/common/double_extension.dart';

class DealModel {
  DealModel({
    required this.gameName,
    required this.price,
    required this.originalPrice,
    required this.thumbnailUrl,
    required this.storeId,
    required this.percentageOff,
  });
  factory DealModel.fromJson(dynamic json) {
    print(json['normalPrice']);
    print(json['salePrice']);
    return DealModel(
      gameName: json['title']!,
      originalPrice: double.parse(json['normalPrice']!),
      price: double.parse(json['salePrice']!),
      thumbnailUrl: json['thumb']!,
      storeId: int.parse(json['storeID']!),
      percentageOff: double.parse(json['savings']!),
    );
  }

  String gameName;
  String thumbnailUrl;
  double price;
  double originalPrice;
  int storeId;
  double percentageOff;

  bool get isFree => price == 0;

  String get formattedPercentageOff => percentageOff.toStringAsDynamic(2);
}
