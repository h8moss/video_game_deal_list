import 'dart:async';
import 'package:dio/dio.dart';
import 'package:video_game_wish_list/models/deal_model.dart';

class GameServer {
  GameServer() {
    _fetchGames();
  }

  Dio _dio = Dio();
  StreamController<List<DealModel>> _gamesStreamController =
      StreamController<List<DealModel>>();

  Stream<List<DealModel>> get games => _gamesStreamController.stream;

  void dispose() => _gamesStreamController.close();

  Future<void> _fetchGames() async {
    final response = await _dio.get('https://www.cheapshark.com/api/1.0/deals');
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      _gamesStreamController
          .add(items.map((e) => DealModel.fromJson(e)).toList());
    }
  }
}
