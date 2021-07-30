import 'package:flutter/material.dart';
import 'package:video_game_wish_list/common/widgets/price_tag.dart';
import 'package:video_game_wish_list/common/widgets/store_display_builder.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';

class DealPage extends StatelessWidget {
  const DealPage({
    Key? key,
    required this.model,
    required this.isFavorite,
    required this.onBookmarkPressed,
  }) : super(key: key);

  final DealModel model;
  final bool isFavorite;
  final VoidCallback? onBookmarkPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.gameName),
        actions: [
          TextButton(
              onPressed: onBookmarkPressed,
              child: Icon(
                isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBasicText(model.gameName),
                ),
                Center(
                    child: Text(
                  'is',
                  style: TextStyle(color: Colors.black38),
                )),
                _buildBasicText(
                  '${model.formattedPercentageOff}% off!',
                ),
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
      ),
    );
  }

  Widget _buildBasicText(String label) {
    return Center(
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
