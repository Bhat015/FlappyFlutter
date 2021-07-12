import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final double birdYAxis;
  static const double birdXAxis = -0.5;
  MyBird({required this.birdYAxis});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.blue,
      duration: Duration(),
      alignment: Alignment(birdXAxis, birdYAxis),
      child: Container(
        height: 60,
        width: 60,
        child: Image.asset('assets/flappy_bird_image.png'),
      ),
    );
  }
}
