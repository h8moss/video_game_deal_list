import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_game_wish_list/services/game_server.dart';

import 'app/home_page/home_page.dart';
import 'app/home_page/home_page_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GameServer>(
      create: (_) => GameServer(),
      child: MaterialApp(
        title: 'Video Game Deal Viewer',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomePageBuilder(),
      ),
    );
  }
}
