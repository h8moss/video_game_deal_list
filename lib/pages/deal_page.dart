import 'package:flutter/material.dart';
import 'package:video_game_wish_list/models/deal_model.dart';

class DealPage extends StatelessWidget {
  static show(BuildContext context, DealModel model) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DealPage(model: model),
    ));
  }

  const DealPage({Key? key, required this.model}) : super(key: key);

  final DealModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model.gameName)),
      body: ListView(
        children: [
          Image.network(model.thumbnailUrl),
          Text(model.gameName),
        ],
      ),
    );
  }
}
