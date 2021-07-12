import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(
              image: AssetImage("assets/flappy_bird_image.png"),
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Flappy Flutter",
                style: TextStyle(fontSize: 24, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
