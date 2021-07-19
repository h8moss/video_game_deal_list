import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/common/store_display.dart';
import 'package:video_game_wish_list/models/store_model.dart';
import 'package:video_game_wish_list/services/game_server.dart';

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
    GameServer server = Provider.of<GameServer>(context);
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
