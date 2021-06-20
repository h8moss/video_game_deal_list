import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GameServer>(
      create: (_) => GameServer(),
      child: MaterialApp(
        title: 'Video Game Viewer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
