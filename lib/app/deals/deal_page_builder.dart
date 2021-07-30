import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';
import 'package:video_game_wish_list/common/services/saved_deal_server.dart';
import 'package:video_game_wish_list/common/widgets/error_page.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';
import 'package:video_game_wish_list/app/deals/deal_page.dart';

import 'models/deal_page_model.dart';

class DealPageBuilder extends StatelessWidget {
  const DealPageBuilder({Key? key, required this.dealID}) : super(key: key);

  final String dealID;

  static show(BuildContext context, String dealID) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DealPageBuilder(dealID: dealID),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final apiServer = Provider.of<ApiDealServer>(context, listen: false);
    final savedServer = Provider.of<SavedDealServer>(context, listen: false);
    final deal = apiServer.getDeal(dealID);
    final savedDeals = savedServer.deals;
    return StreamBuilder<DealPageModel?>(
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null)
          return DealPage(
            model: snapshot.data!.deal,
            isFavorite: snapshot.data!.isSaved,
            onBookmarkPressed: () {
              if (snapshot.data!.isSaved)
                savedServer.removeDeal(snapshot.data!.deal);
              else
                savedServer.addDeal(snapshot.data!.deal);
            },
          );
        else if (snapshot.hasError) return ErrorPage();

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      stream: Rx.combineLatest2<DealModel?, List<String>, DealPageModel?>(
        deal,
        savedDeals,
        (a, b) => a != null
            ? DealPageModel(deal: a, isSaved: b.contains(a.id))
            : null,
      ),
    );
  }
}
