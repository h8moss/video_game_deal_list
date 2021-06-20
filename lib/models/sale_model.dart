class SaleModel {
  SaleModel({
    required this.gameName,
    required this.price,
    required this.originalPrice,
  });
  factory SaleModel.fromJson(dynamic json) {
    return SaleModel(
      gameName: json['title'],
      originalPrice: 0,
      price: 0,
    );
  }
  String gameName;
  double price;
  double originalPrice;
}
