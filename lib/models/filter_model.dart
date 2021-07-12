class FilterModel {
  FilterModel({
    this.higherPrice,
    this.lowerPrice,
    this.stores: const [],
  });

  int? higherPrice;
  int? lowerPrice;
  List<int> stores;
}
