import 'deal_model.dart';

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
