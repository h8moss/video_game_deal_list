import 'package:flutter/material.dart';
import 'package:video_game_wish_list/common/models/store_model.dart';

class StoreDisplay extends StatelessWidget {
  const StoreDisplay({
    Key? key,
    required this.model,
    this.width,
    this.height,
    this.textColor,
  }) : super(key: key);

  final StoreModel model;
  final double? width;
  final double? height;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Image.network(model.icon),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: TextStyle(color: textColor),
              ),
              if (!model.isActive)
                Text('Inactive',
                    style: TextStyle(color: Colors.red, fontSize: 10))
            ],
          ),
        ),
        SizedBox(width: 50),
      ],
    );
  }
}
