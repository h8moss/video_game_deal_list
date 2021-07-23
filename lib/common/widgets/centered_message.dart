import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {
  const CenteredMessage({
    Key? key,
    required this.message,
    this.secondaryMessage,
  }) : super(key: key);

  final String message;
  final String? secondaryMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message, style: TextStyle(fontSize: 25)),
        if (secondaryMessage != null)
          Text(
            secondaryMessage!,
            style: TextStyle(color: Colors.black54),
          ),
      ],
    ));
  }
}
