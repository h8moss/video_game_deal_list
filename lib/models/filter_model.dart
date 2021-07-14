class FilterModel {
  const FilterModel({
    this.higherPrice,
    this.lowerPrice,
    this.stores: const [],
  });

  final int? higherPrice;
  final int? lowerPrice;
  final List<int> stores;
}
