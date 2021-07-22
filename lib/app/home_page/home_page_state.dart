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
    List<DealModel>? deals,
    FilterModel? filter,
  }) {
    return HomePageState(
      deals: deals ?? this.deals,
      filter: filter ?? this.filter,
    );
  }

  int get dealCount => deals?.length ?? 0;
}
