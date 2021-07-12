import 'package:flutter/material.dart';

class TwoLineWidget extends StatelessWidget {
  final String title;
  final String subTitle;

  TwoLineWidget({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          subTitle,
          style: TextStyle(color: Colors.white, fontSize: 38),
        ),
      ],
    );
  }
}
