import 'package:video_game_wish_list/app/deals/models/deal_results.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';

abstract class DealServer {
  /// asynchronously fetch the games from the source from the specified
  /// [page] using the specified [filter] and with the specified [search]
  Future<DealResults> fetchDeals(int page, FilterModel filter, String search);

  abstract final bool hasSearch;
  abstract final bool hasFilter;

  Future<void> initialize() async {}

  void dispose() {}
}
