import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/deals/models/deal_results.dart';
import 'package:video_game_wish_list/app/deals/models/deal_sorting_Style.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

import 'deal_server.dart';

/// API to connext to cheapshark and fetch deals.
class ApiDealServer extends DealServer {
  ApiDealServer();

  Dio _dio = Dio();
  static String _domain = 'https://www.cheapshark.com/api/1.0';

  static String get dealsUrl => '$_domain/deals';
  static String get storesUrl => '$_domain/stores';

  @override
  Future<DealResults> fetchDeals(
    int page,
    FilterModel filter,
    String search,
  ) async {
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

  /// Asynchronously returns a List of all stores as store models.
  Future<List<StoreModel>> getAllStores() async {
    final response = await _dio.get(storesUrl);
    if (response.statusCode == 200) {
      List<dynamic> items = response.data;
      return items.map((e) => StoreModel.fromJson(e)).toList();
    }
    throw HttpException('Could not connect to the API');
  }

  /// Asynchronously returns a Single store model with the corresponding [storeID]
  /// or null if no [storeID] matches.
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

  /// Asynchronously returns a Single deal model with the corresponding [dealID]
  /// or null if no [dealID] matches.
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
    if (search.isNotEmpty) result += 'title=$search&';
    if (!filter.isDescending) result += 'desc=1&';
    if (filter.useLowerPrice) result += 'lowerPrice=${filter.lowerPrice}&';
    if (filter.useMetacriticScore)
      result += 'metacritic=${filter.metacriticScore}&';
    if (filter.sorting != DealSortingStyle.Rating)
      result += 'sortBy=${_getSortTitle(filter.sorting)}&';
    if (filter.useSteamScore) result += 'steamRating=${filter.steamScore}&';
    if (filter.stores.length != 0) {
      var storeText = filter.stores
          .fold('', (previousValue, element) => '$previousValue${element.id},');
      storeText = storeText.substring(0, storeText.length - 1);

      result += 'storeID=$storeText&';
    }
    if (filter.useUpperPrice) result += 'upperPrice=${filter.upperPrice}&';
    if (filter.isAAA) result += 'AAA=1&';
    if (filter.isActive) result += 'onSale=1&';
    if (filter.steamWorks) result += 'steamworks=1&';

    print(result.substring(0, result.length - 1));

    return result.substring(0, result.length - 1);
  }

  String _getSortTitle(DealSortingStyle sorting) {
    switch (sorting) {
      case DealSortingStyle.Metacritic:
        return 'Metacritic';
      case DealSortingStyle.Price:
        return 'Price';
      case DealSortingStyle.Rating:
        return 'DealRating';
      case DealSortingStyle.Title:
        return 'Title';
      case DealSortingStyle.Savings:
        return 'Savings';
      case DealSortingStyle.Reviews:
        return 'Reviews';
      case DealSortingStyle.Release:
        return 'Release';
      case DealSortingStyle.Store:
        return 'Store';
      case DealSortingStyle.Recent:
        return 'recent';
    }
  }

  @override
  final bool hasFilter = true;

  @override
  final bool hasSearch = true;
}
