import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';

class GameServer {
  GameServer();

  Dio _dio = Dio();

  /// asynchronously fetch the games from the cheap shark api from the specified
  /// [page]
  Future<DealResults> fetchGames(int page) async {
    final response = await _dio
        .get('https://www.cheapshark.com/api/1.0/deals?pageNumber=$page');
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      print(response.headers.value('X-Total-Page-Count'));
      return DealResults(
        currentResults: 60,
        page: page,
        results: items.map((e) => DealModel.fromJson(e)).toList(),
        totalPages:
            int.parse(response.headers.value('X-Total-Page-Count') ?? '0'),
      );
    }
    throw HttpException(
        'Could not connect to the cheap shark API: status code: ${response.statusCode}');
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

  Stream<DealModel?> getDeal(String dealID) async* {
    yield null;
    final response =
        await _dio.get('https://www.cheapshark.com/api/1.0/deals?id=$dealID');
    if (response.statusCode == 200) {
      try {
        var obj = response.data as Map<String, dynamic>;
        yield DealModel.fromGameInfoJson(obj, dealID);
      } on TypeError catch (_) {
        throw ArgumentError.value(dealID, 'dealID');
      }
    } else
      throw HttpException('Could not reach deals API ${response.statusCode}');
  }
}

class DealResults {
  DealResults({
    required this.currentResults,
    required this.page,
    required this.results,
    required this.totalPages,
  });
  final int page;
  final int totalPages;
  final int currentResults;
  final List<DealModel> results;
}
