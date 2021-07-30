import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/common/services/api_deal_server.dart';
import 'package:video_game_wish_list/common/widgets/store_display.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

class StoreDisplayBuilder extends StatelessWidget {
  const StoreDisplayBuilder({
    Key? key,
    required this.storeID,
    this.height,
    this.textColor,
    this.width,
  }) : super(key: key);

  final int storeID;
  final double? height;
  final double? width;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    ApiDealServer server = Provider.of<ApiDealServer>(context, listen: false);
    Stream<StoreModel?> store = server.getStore(storeID);
    return StreamBuilder<StoreModel?>(
      stream: store,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Center(
              child: StoreDisplay(
            model: snapshot.data!,
            height: height,
            textColor: textColor,
            width: width,
          ));
        } else if (snapshot.hasError) {
          return Text('Could not find the store');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
