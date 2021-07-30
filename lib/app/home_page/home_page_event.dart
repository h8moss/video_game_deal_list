import 'package:flutter/cupertino.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';

class HomePageEvent {
  HomePageEvent();
}

class AppendDealsEvent extends HomePageEvent {
  AppendDealsEvent(this.deals) : super();

  final List<DealModel> deals;
}

class SetDealsEvent extends HomePageEvent {
  SetDealsEvent(this.deals) : super();

  final List<DealModel>? deals;
}

class SetFilterEvent extends HomePageEvent {
  SetFilterEvent(this.filter);

  FilterModel filter;
}

class RenderItemEvent extends HomePageEvent {
  RenderItemEvent(this.index);

  int index;
}

class FilterButtonPressedEvent extends HomePageEvent {
  FilterButtonPressedEvent(this.context);

  BuildContext context;
}

class GetInitialPageEvent extends HomePageEvent {}

class SetHasErrorEvent extends HomePageEvent {
  SetHasErrorEvent(this.value);

  bool value;
}

class RetryLoadingButtonEvent extends HomePageEvent {}

class SetIsSearchingEvent extends HomePageEvent {
  SetIsSearchingEvent(this.value);

  final bool value;
}

class SetSearchTermEvent extends HomePageEvent {
  SetSearchTermEvent(this.value);

  final String value;
}

class SetBottomNavigationEvent extends HomePageEvent {
  SetBottomNavigationEvent(this.value);

  final int value;
}
