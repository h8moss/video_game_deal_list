import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  const PriceTag(this.price,
      {Key? key,
      this.textColor,
      this.textDecoration,
      this.backgroundColor,
      this.semanticsLabel})
      : super(key: key);

  PriceTag.green(double price, {String? semanticsLabel})
      : this(
          price,
          backgroundColor: Colors.green[100],
          semanticsLabel: semanticsLabel,
          textColor: Colors.green,
        );

  PriceTag.red(double price, {String? semanticsLabel})
      : this(
          price,
          backgroundColor: Colors.red[100],
          textColor: Colors.red,
          textDecoration: TextDecoration.lineThrough,
          semanticsLabel: semanticsLabel,
        );

  final double price;
  final TextDecoration? textDecoration;
  final Color? backgroundColor;
  final Color? textColor;
  final String? semanticsLabel;

  bool get isZero => price == 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          isZero ? 'Free' : '${price.toStringAsFixed(2)}\$',
          style: TextStyle(
              decoration: textDecoration, color: textColor, fontSize: 13),
          semanticsLabel: semanticsLabel,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: backgroundColor,
      ),
    );
  }
}
