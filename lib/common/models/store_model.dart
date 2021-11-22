import 'package:equatable/equatable.dart';

/// Simple model class for accepted stores.
class StoreModel extends Equatable {
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

  String describe() => name;

  /// Unique numeric ID of the store
  final int id;

  /// name of the store
  final String name;

  /// Weather the store is still active.
  final bool isActive;

  /// Url to icon image of the store
  final String icon;

  @override
  List<Object?> get props => [id, name, isActive, icon];
}
