class DealModel {
  DealModel({
    required this.gameName,
    required this.price,
    required this.originalPrice,
    required this.thumbnailUrl,
    required this.storeId,
  });
  factory DealModel.fromJson(dynamic json) {
    print(json['normalPrice']);
    print(json['salePrice']);
    return DealModel(
      gameName: json['title'],
      originalPrice: double.parse(json['normalPrice']),
      price: double.parse(json['salePrice']),
      thumbnailUrl: json['thumb'],
      storeId: int.parse(json['storeID']),
    );
  }

  String gameName;
  String thumbnailUrl;
  double price;
  double originalPrice;
  int storeId;

  bool get isFree => price == 0;
}
