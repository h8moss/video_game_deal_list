import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/common/error_page.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/app/deals/deal_page.dart';
import 'package:video_game_wish_list/services/game_server.dart';

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
    final server = Provider.of<GameServer>(context);
    Stream<DealModel?> deal = server.getDeal(dealID);
    return StreamBuilder<DealModel?>(
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null)
          return DealPage(model: snapshot.data!);
        else if (snapshot.hasError) return ErrorPage();

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      stream: deal,
    );
  }
}
