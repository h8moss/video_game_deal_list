import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/models/sale_model.dart';
import 'package:video_game_wish_list/sale_tile.dart';
import 'package:video_game_wish_list/services/game_server.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameServer = Provider.of<GameServer>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<SaleModel>>(
        initialData: [],
        stream: gameServer.games,
        builder: (context, snapshot) => GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) =>
              _buildGridItem(context, snapshot.data![index]),
          itemCount: snapshot.data!.length,
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, SaleModel model) {
    return SaleTile(model);
  }
}
