import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double size;
  MyBarrier({required this.size});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final height = (screenHeight/8) * (size/100); 
    return Container(
      width: 80,
      height: height,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(width: 10, color: Colors.green[800]!,),
        borderRadius: BorderRadius.circular(10)
      ),
      
    );
  }
}