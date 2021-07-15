import 'package:video_game_wish_list/models/deal_model.dart';

class HomePageEvent {
  HomePageEvent();
}

class AppendDealsEvent extends HomePageEvent {
  AppendDealsEvent(this.deals) : super();

  final List<DealModel> deals;
}

class SetDealsEvent extends HomePageEvent {
  SetDealsEvent(this.deals) : super();

  final List<DealModel> deals;
}
