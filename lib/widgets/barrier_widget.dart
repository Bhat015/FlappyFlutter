import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierHeight;
  final double barrierXAxis;
  final double barrierYAxis;

  MyBarrier(
      {required this.barrierHeight,
      required this.barrierXAxis,
      required this.barrierYAxis});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final height = (screenHeight / 8) * (barrierHeight / 100);
    return AnimatedContainer(
      duration: Duration(),
      alignment: Alignment(barrierXAxis, barrierYAxis),
      child: Container(
        width: 80,
        height: height,
        decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              width: 10,
              color: Colors.green[800]!,
            ),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
