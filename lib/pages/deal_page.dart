import 'package:flutter/material.dart';
import 'package:video_game_wish_list/common/price_tag.dart';
import 'package:video_game_wish_list/common/store_display_builder.dart';
import 'package:video_game_wish_list/models/deal_model.dart';

class DealPage extends StatelessWidget {
  static show(BuildContext context, DealModel model) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DealPage(model: model),
    ));
  }

  const DealPage({Key? key, required this.model}) : super(key: key);

  final DealModel model;

  TextStyle get _basicTextStyle => TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(model.gameName)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                    child: Image.network(model.thumbnailUrl),
                    fit: BoxFit.fitWidth),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PriceTag(
                    model.originalPrice,
                    textDecoration: TextDecoration.lineThrough,
                    textColor: Colors.red,
                    backgroundColor: Colors.red[100],
                  ),
                  PriceTag(
                    model.price,
                    textColor: Colors.green,
                    backgroundColor: Colors.green[100],
                  ),
                ],
              ),
              Center(
                child: Text(
                  model.gameName,
                  style: _basicTextStyle,
                ),
              ),
              Center(
                  child: Text(
                'is',
                style: TextStyle(color: Colors.black38),
              )),
              Center(
                  child: Text(
                '${model.formattedPercentageOff}% off!',
                style: _basicTextStyle,
              )),
              Center(
                  child: Text(
                'at',
                style: TextStyle(color: Colors.black38),
              )),
              Center(child: StoreDisplayBuilder(storeID: model.storeId)),
            ],
          ),
        ),
      ),
    );
  }
}
