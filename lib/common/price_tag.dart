import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  const PriceTag(this.price,
      {Key? key, this.textColor, this.textDecoration, this.backgroundColor})
      : super(key: key);

  final double price;
  final TextDecoration? textDecoration;
  final Color? backgroundColor;
  final Color? textColor;

  bool get isZero => price == 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(isZero ? 'Free' : '${price.toStringAsFixed(2)}\$',
            style: TextStyle(
                decoration: textDecoration, color: textColor, fontSize: 13)),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
    );
  }
}
