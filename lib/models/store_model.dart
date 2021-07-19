import 'package:flutter/cupertino.dart';

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

  operator ==(dynamic other) {
    return (other != null &&
        other is StoreModel &&
        other.icon == icon &&
        other.id == id &&
        other.isActive == isActive &&
        other.name == name);
  }

  @override
  int get hashCode => hashValues(id, name, isActive, icon);
}
