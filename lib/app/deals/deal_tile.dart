import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_game_wish_list/common/widgets/price_tag.dart';
import 'package:video_game_wish_list/app/deals/models/deal_model.dart';

/// Display for a deal in a list
class DealTile extends StatelessWidget {
  DealTile({required this.saleModel, required this.onPressed});

  final DealModel saleModel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: saleModel.description(),
        child: TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(saleModel.thumbnailUrl,
                        errorBuilder: (context, exception, stacktrace) =>
                            Text('Error loading image...')),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        saleModel.gameName,
                        style: TextStyle(color: Colors.black87),
                        semanticsLabel: '',
                      ),
                      Row(
                        children: [
                          PriceTag.red(
                            saleModel.originalPrice,
                            semanticsLabel: '',
                          ),
                          SizedBox(width: 8),
                          PriceTag.green(
                            saleModel.price,
                            semanticsLabel: '',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
