import 'package:flutter/material.dart';

import 'centered_message.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: CenteredMessage(
        message: 'Something went wrong',
        secondaryMessage: 'Please try again later',
      ),
    );
  }
}
