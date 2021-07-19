import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/models/filter_model.dart';
import 'package:video_game_wish_list/models/store_model.dart';

class GameServer {
  GameServer();

  Dio _dio = Dio();
  static String domain = 'https://www.cheapshark.com/api/1.0';

  static String get dealsUrl => '$domain/deals';
  static String get storesUrl => '$domain/stores';

  /// asynchronously fetch the games from the cheap shark api from the specified
  /// [page]
  Future<DealResults> fetchGames(int page, FilterModel filter,
      [String search = '']) async {
    String query = _getQuery(page, filter, search);
    final response = await _dio.get('$dealsUrl$query');
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

  Future<List<StoreModel>?> getAllStores() async {
    final response = await _dio.get(storesUrl);
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      return items.map((e) => StoreModel.fromJson(e)).toList();
    }
  }

  Stream<StoreModel?> getStore(int storeID) async* {
    yield null;
    final response = await _dio.get(storesUrl);
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
    final response = await _dio.get('$dealsUrl?id=$dealID');
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

  String _getQuery(int page, FilterModel filter, String search) {
    if (page == 0 && filter.isDefault && search.isEmpty) return '';
    var result = '?';
    if (page != 0) result += 'pageNumber=$page&';
    if (!filter.isDescending) result += 'desc=1&';
    if (filter.lowerPrice != null) result += 'lowerPrice=${filter.lowerPrice}&';
    if (filter.metacriticScore != null)
      result += 'metacritic=${filter.metacriticScore}&';
    if (filter.sorting != DealSorting.Rating)
      result += 'sortBy=${_getSortTitle(filter.sorting)}&';
    if (filter.steamScore != null)
      result += 'steamRating=${filter.steamScore}&';
    if (filter.stores.length != 0) {
      var storeText = filter.stores
          .fold('', (previousValue, element) => '$previousValue${element.id},');
      storeText = storeText.substring(0, storeText.length - 2);

      result += 'storeID=$storeText&';
    }
    if (filter.upperPrice != null) result += 'upperPrice=${filter.upperPrice}&';

    print(result.substring(0, result.length - 1));

    return result.substring(0, result.length - 1);
  }

  String _getSortTitle(DealSorting sorting) {
    switch (sorting) {
      case DealSorting.Metacritic:
        return 'Metacritic';
      case DealSorting.Price:
        return 'Price';
      case DealSorting.Rating:
        return 'DealRating';
      case DealSorting.Title:
        return 'Title';
      case DealSorting.Savings:
        return 'Savings';
      case DealSorting.Reviews:
        return 'Reviews';
      case DealSorting.Release:
        return 'Release';
      case DealSorting.Store:
        return 'Store';
      case DealSorting.Recent:
        return 'recent';
    }
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
