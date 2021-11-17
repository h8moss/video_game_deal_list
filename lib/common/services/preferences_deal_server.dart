import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/app/deals/models/deal_results.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';
import 'package:video_game_wish_list/common/services/deal_server.dart';

/// Deal server for saved preferences, used to store favorite items
class PreferencesDealServer extends DealServer {
  PreferencesDealServer(this.apiDealServer);

  final String _dealsKey = 'deals';
  final ApiDealServer apiDealServer;

  BehaviorSubject<List<String>> _dealsSubject = BehaviorSubject.seeded([]);
  bool _isInitialized = false;

  @override
  void dispose() {
    _dealsSubject.close();
    _isInitialized = false;
    super.dispose();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _readData();
    _isInitialized = true;
  }

  @override
  Future<DealResults> fetchDeals(
    int page,
    FilterModel filter,
    String search,
  ) async {
    _assertInitialization();
    var currentDealIds = await deals.first;
    var currentDeals = await Future.wait(
        currentDealIds.map((e) async => await apiDealServer.getDeal(e).last));
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

  /// adds a deal [model] to preferences
  Future<void> addDeal(DealModel model) async {
    _assertInitialization();
    var currentDeals = await deals.first;
    _setData(currentDeals..add(model.id));
  }

  /// removes a deal [model] from preferences if present
  Future<void> removeDeal(DealModel model) async {
    _assertInitialization();
    var currentDeals = await deals.first;
    _setData(currentDeals..remove(model.id));
  }

  /// returns true if [model] is stored in the preferences
  Future<bool> isStored(DealModel model) async {
    _assertInitialization();
    var currentDeals = await deals.first;
    return currentDeals.contains(model.id);
  }

  Future<void> _setData(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    _dealsSubject.value = value;
    prefs.setStringList(_dealsKey, value);
  }

  Future<void> _readData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? values = prefs.getStringList(_dealsKey);
    if (values != null && values.isNotEmpty) {
      _dealsSubject.add(values);
    }
  }

  /// Stream of currently saved deals
  Stream<List<String>> get deals => _dealsSubject.stream;

  void _assertInitialization() {
    if (!_isInitialized) throw 'server not initialized';
  }

  @override
  final bool hasFilter = false;

  @override
  final bool hasSearch = true;
}
