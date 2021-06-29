import 'package:flutter/material.dart';
import 'package:video_game_wish_list/common/price_tag.dart';

import 'models/deal_model.dart';

class DealTile extends StatelessWidget {
  DealTile({required this.saleModel, required this.onPressed});

  final DealModel saleModel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
                  child: Image.network(
                    saleModel.thumbnailUrl,
                  )),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(saleModel.gameName,
                      style: TextStyle(color: Colors.black87)),
                  Row(
                    children: [
                      PriceTag(
                        saleModel.originalPrice,
                        textColor: Colors.red,
                        textDecoration: TextDecoration.lineThrough,
                        backgroundColor: Colors.red[100],
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      PriceTag(
                        saleModel.price,
                        textColor: Colors.green,
                        backgroundColor: Colors.green[100],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
