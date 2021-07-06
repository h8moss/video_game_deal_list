import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Something went wrong', style: TextStyle(fontSize: 25)),
          Text(
            'Please try again later',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      )),
    );
  }
}
