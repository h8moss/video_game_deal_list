class StoreModel {
  StoreModel(
      {required this.id,
      required this.isActive,
      required this.name,
      required this.icon});

  factory StoreModel.fromJson(dynamic json) {
    return StoreModel(
      id: int.parse(json['storeID']),
      isActive: json['isActive'] == 1,
      name: json['storeName'],
      icon: 'https://www.cheapshark.com${json['images']['logo']}',
    );
  }
  final int id;
  final String name;
  final bool isActive;
  final String icon;
}
