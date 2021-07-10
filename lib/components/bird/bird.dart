import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 60,
      width: 60,
      child: Image.asset('assets/flappy_bird_image.png'));
  }
}