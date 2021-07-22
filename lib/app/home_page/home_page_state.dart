import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';

class HomePageState {
  HomePageState({
    this.deals,
    this.filter: const FilterModel(),
  });

  final List<DealModel>? deals;
  final FilterModel filter;

  HomePageState updateWith({
    List<DealModel>? deals = const [_MarkedDealModel()],
    FilterModel? filter,
  }) {
    bool dealsDefault =
        deals != null && deals.length == 1 && deals[0] is _MarkedDealModel;
    return HomePageState(
      deals: dealsDefault ? this.deals : deals,
      filter: filter ?? this.filter,
    );
  }

  int get dealCount => deals?.length ?? 0;
}

/// Simple class that cannot be used outside of this file, this differentiates
/// passing a null value and no value at all to deals in the update with method.
class _MarkedDealModel extends DealModel {
  const _MarkedDealModel()
      : super(
          gameName: '',
          id: '0',
          originalPrice: 0,
          percentageOff: 0,
          price: 0,
          storeId: 0,
          thumbnailUrl: '',
        );
}
