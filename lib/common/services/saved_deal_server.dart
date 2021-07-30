import 'package:localstorage/localstorage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/app/deals/models/deal_results.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';
import 'package:video_game_wish_list/common/services/deal_server.dart';

class SavedDealServer extends DealServer {
  SavedDealServer(this.apiDealServer);

  final LocalStorage storage = LocalStorage('saved_deals');
  final String _dealsKey = 'deals';
  final ApiDealServer apiDealServer;

  BehaviorSubject<List<String>> _dealsSubject = BehaviorSubject.seeded([]);

  void dispose() {
    _dealsSubject.close();
  }

  @override
  Future<DealResults> fetchDeals(
    int page,
    FilterModel filter,
    String search,
  ) async {
    var currentDealIds = await deals.first;
    var currentDeals = await Future.wait(
        currentDealIds.map((e) async => await apiDealServer.getDeal(e).last));
    //List<DealModel> finalDeals = []
    //for (int i=page*60; i<(page+1)*60; i++) {
    //  if (i >= deals.length) break;
    //  if (deals[i]!=null && deals[i]!.gameName.contains(search)) finalDeals.add(deals[i]!);
    //}
    return DealResults(
        currentResults: 60,
        page: page,
        results: currentDeals
            .where((element) =>
                element != null && element.gameName.contains(search))
            .map((v) => v!)
            .skip(page * 60)
            .take(60)
            .toList(),
        totalPages: (currentDeals.length / 60).ceil());
  }

  Future<void> addDeal(DealModel model) async {
    var currentDeals = await deals.first;
    _setData(currentDeals..add(model.id));
  }

  Future<void> removeDeal(DealModel model) async {
    var currentDeals = await deals.first;
    _setData(currentDeals..remove(model.id));
  }

  Future<bool> isStored(DealModel model) async {
    var currentDeals = await deals.first;
    return currentDeals.contains(model.id);
  }

  Future<void> _setData(List<String> value) async {
    await storage.ready;
    _dealsSubject.value = value;
    storage.setItem(_dealsKey, value);
  }

  Stream<List<String>> get deals => _dealsSubject.stream;

  @override
  final bool hasFilter = false;

  @override
  final bool hasSearch = true;
}
