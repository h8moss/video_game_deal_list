import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/home_page/home_page_builder.dart';
import 'common/services/game_server.dart';

void main() => runApp(MyApp());

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
