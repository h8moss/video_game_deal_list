import 'package:flutter/cupertino.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/filtering/models/filter_model.dart';

class HomePageEvent {
  HomePageEvent();
}

class AppendDeals extends HomePageEvent {
  AppendDeals(this.deals) : super();

  final List<DealModel> deals;
}

class SetDeals extends HomePageEvent {
  SetDeals(this.deals) : super();

  final List<DealModel>? deals;
}

class SetFilter extends HomePageEvent {
  SetFilter(this.filter);

  FilterModel filter;
}

class RenderItem extends HomePageEvent {
  RenderItem(this.index);

  int index;
}

class FilterButtonPressed extends HomePageEvent {
  FilterButtonPressed(this.context);

  BuildContext context;
}

class GetInitialPage extends HomePageEvent {}

class SetHasError extends HomePageEvent {
  SetHasError(this.value);

  bool value;
}

class RetryLoadingButton extends HomePageEvent {}

class SetIsSearching extends HomePageEvent {
  SetIsSearching(this.value);

  final bool value;
}

class SetSearchTerm extends HomePageEvent {
  SetSearchTerm(this.value);

  final String value;
}

class UpdateSearchTerm extends HomePageEvent {
  UpdateSearchTerm(this.value);

  final String value;
}

class SetBottomNavigation extends HomePageEvent {
  SetBottomNavigation(this.value);

  final int value;
}
