import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';

class GameServer {
  GameServer() {
    _fetchGames();
  }

  Dio _dio = Dio();
  StreamController<List<DealModel>> _gamesStreamController =
      StreamController<List<DealModel>>();

  Stream<List<DealModel>> get games => _gamesStreamController.stream;

  void dispose() {
    _gamesStreamController.close();
  }

  Future<void> _fetchGames() async {
    final response = await _dio.get('https://www.cheapshark.com/api/1.0/deals');
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      _gamesStreamController
          .add(items.map((e) => DealModel.fromJson(e)).toList());
    }
  }

  Stream<StoreModel?> getStore(int storeID) async* {
    yield null;
    final response =
        await _dio.get('https://www.cheapshark.com/api/1.0/stores');
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      if (storeID <= items.length)
        yield StoreModel.fromJson(items[storeID - 1]);
      else
        throw ArgumentError.value(storeID, 'storeID');
    } else
      throw HttpException('Could not reach stores API: ${response.statusCode}');
  }
}
