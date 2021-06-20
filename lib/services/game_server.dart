import 'dart:async';
import 'package:dio/dio.dart';
import 'package:video_game_wish_list/models/sale_model.dart';

class GameServer {
  GameServer() {
    _fetchGames();
  }

  Dio _dio = Dio();
  StreamController<List<SaleModel>> _gamesStreamController =
      StreamController<List<SaleModel>>();

  Stream<List<SaleModel>> get games => _gamesStreamController.stream;

  void dispose() => _gamesStreamController.close();

  Future<void> _fetchGames() async {
    final response = await _dio.get('https://www.cheapshark.com/api/1.0/deals');
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      _gamesStreamController
          .add(items.map((e) => SaleModel.fromJson(e)).toList());
    }
  }
}
