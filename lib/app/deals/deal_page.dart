import 'package:flutter/material.dart';
import 'package:video_game_wish_list/common/widgets/price_tag.dart';
import 'package:video_game_wish_list/common/widgets/store_display_builder.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';

class DealPage extends StatelessWidget {
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
                  PriceTag.red(model.originalPrice),
                  PriceTag.green(model.price),
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
              Center(
                  child: StoreDisplayBuilder(
                storeID: model.storeId,
                width: 50,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
