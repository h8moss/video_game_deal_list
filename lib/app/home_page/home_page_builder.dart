import 'package:flutter/material.dart';
import 'package:video_game_wish_list/app/home_page/home_page.dart';

/// Abstraction of the creation of the home page to facilitate calling
/// provider with context
class HomePageBuilder extends StatelessWidget {
  const HomePageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage.create(context);
  }
}
