import 'dart:async';
import 'dart:ui';
import 'package:flappy_flutter/components/barriers/barrier.dart';
import 'package:flappy_flutter/components/bird/bird.dart';
import 'package:flappy_flutter/components/clouds/clouds.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double birdYaxis = 0;
  static double barrierXOne = 0.9;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool isStartGame = false;
  bool isBarrierTouched = false;
  double barrierXTwo = barrierXOne + 1.8;
  int score = 0;
  late SharedPreferences prefs;
  int bestScore = 0;

  @override
  initState() {
    getHighScore();
    super.initState();
  }

  Future<void> getHighScore() async {
    // get high score from local db
    prefs = await SharedPreferences.getInstance();
    bestScore = prefs.getInt("HighScore") ?? 0;
  }

  void jump(BuildContext context) {
    setState(() {
      //on every new jump
      //time is set to 0, since new jump, new parabolic function is needed with time 0
      // height is the current height as new jump is needed from current height
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame(BuildContext context) {
    isStartGame = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) async {
      time = time + 0.04;

      // Parabolic function
      // yaxis = height = (-g(t)^2 )/ 2 + vt
      // considering g as 9.8 and v as 2.8
      height = (-4.9 * (time * time)) + 2.8 * time;

      //moving the bird
      setState(() {
        birdYaxis = initialHeight - height;
      });

      //moving barrier one
      setState(() {
        if (barrierXOne < -2) {
          barrierXOne += 3.5;
        } else {
          barrierXOne -= 0.05;
        }
      });

      //moving barrier two
      setState(() {
        if (barrierXTwo < -2) {
          barrierXTwo += 3.5;
        } else {
          barrierXTwo -= 0.05;
        }
      });

      //update score on crossing barrier one
      setState(() {
        if (barrierXOne < -0.75 && barrierXOne > -0.79) {
          score += 1;
        }
      });

      //update score on crossing barrier two
      setState(() {
        if (barrierXTwo < -0.74 && barrierXTwo > -0.78) {
          score += 1;
        }
      });

      //isBarrierTouched check for barrier one
      setState(() {
        if (barrierXOne < -0.20 && barrierXOne > -0.75) {
          if (birdYaxis < -0.33 || birdYaxis > 0.33) {
            isBarrierTouched = true;
          }
        }
      });

      //isBarrierTouched check for barrier two
      setState(() {
        if (barrierXTwo < -0.19 && barrierXTwo > -0.74) {
          if (birdYaxis < 0.095 || birdYaxis > 0.63) {
            isBarrierTouched = true;
          }
        }
      });

      //On Barrier touched or bird hit floor
      if (birdYaxis >= 1 || isBarrierTouched) {
        showGameOverDialog();
        timer.cancel();
        isStartGame = false;
        bestScore = score > bestScore ? score : bestScore;
        // store score in local db, so that highscore is saved to fetch even when opens next time
        await prefs.setInt("HighScore", bestScore);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isStartGame) {
          jump(context);
        } else {
          startGame(context);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(-0.5, birdYaxis),
                    duration: const Duration(milliseconds: 1),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, 1.1),
                    duration: const Duration(milliseconds: 1),
                    child: MyBarrier(size: 180.0),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, 1.1),
                    duration: const Duration(milliseconds: 1),
                    child: MyBarrier(size: 120.0),
                  ),

                  Align(
                    alignment: Alignment(barrierXOne, -0.85),
                    child: MyClouds(),
                  ),
                  //Second two barriers
                  AnimatedContainer(
                    alignment: Alignment(barrierXTwo, -1.1),
                    duration: const Duration(milliseconds: 1),
                    child: MyBarrier(size: 250.0),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXOne, -1.1),
                    duration: const Duration(milliseconds: 1),
                    child: MyBarrier(size: 180.0),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 28),
                    color: Colors.brown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Score",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Text(
                              score.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 38),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "High Score",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Text(
                              bestScore.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 38),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !isStartGame,
                    child: Align(
                      alignment: Alignment(0, -0.8),
                      child: Text(
                        "T A P   T O   P L A Y",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "GAME OVER",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  birdYaxis = 0;
                  barrierXOne = 0.9;
                  time = 0;
                  height = 0;
                  initialHeight = birdYaxis;
                  isStartGame = false;
                  barrierXTwo = barrierXOne + 1.8;
                  score = 0;
                  isBarrierTouched = false;
                });
                Navigator.pop(context);
              },
              child: Text(
                "Play Again",
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
    );
  }
}
