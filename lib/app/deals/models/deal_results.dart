import 'deal_model.dart';

/// A result of a search of deals
class DealResults {
  DealResults({
    required this.currentResults,
    required this.page,
    required this.results,
    required this.totalPages,
  });

  /// current page number
  final int page;

  /// total number of pages with equal search terms
  final int totalPages;

  /// number of results per page
  final int currentResults;

  /// list of results as instances of [DealModel]
  final List<DealModel> results;
}
