import 'deal_model.dart';

/// Deal model with added isSaved property
class DealPageModel {
  DealPageModel({required this.deal, required this.isSaved});

  final DealModel deal;
  final bool isSaved;
}
