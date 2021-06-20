import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'models/game_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameServer = Provider.of<GameServer>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<GameModel>>(
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

  Widget _buildGridItem(BuildContext context, GameModel model) {
    return Center(child: Text(model.name));
  }
}
