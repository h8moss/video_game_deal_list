import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/models/deal_model.dart';
import 'package:video_game_wish_list/deal_tile.dart';
import 'package:video_game_wish_list/pages/deal_page.dart';
import 'package:video_game_wish_list/services/game_server.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameServer = Provider.of<GameServer>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Discover deals')),
      body: StreamBuilder<List<DealModel>>(
          initialData: [],
          stream: gameServer.games,
          builder: (context, snapshot) {
            return ListView.separated(
                separatorBuilder: (_, __) => Divider(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    _buildGridItem(context, snapshot.data![index]));
          }),
    );
  }

  Widget _buildGridItem(BuildContext context, DealModel model) {
    return Center(
      child: DealTile(
        onPressed: () => DealPage.show(context, model),
        saleModel: model,
      ),
    );
  }
}
