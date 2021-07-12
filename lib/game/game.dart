import 'package:flappy_flutter/game/game_bloc.dart';
import 'package:flappy_flutter/widgets/barrier_widget.dart';
import 'package:flappy_flutter/widgets/bird_widget.dart';
import 'package:flappy_flutter/widgets/cloud_widget.dart';
import 'package:flappy_flutter/widgets/splash_screen_widget.dart';
import 'package:flappy_flutter/widgets/two_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Game extends StatelessWidget {
  static late GameBloc _bloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc()..add(OnInitialiseGame()),
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameProgressUpdated) {
            if (state.birdYaxis > 1 || state.isBarrierTouched) {
              showGameOverDialog(context);
              return;
            }
          }
        },
        builder: (context, state) {
          _bloc = BlocProvider.of<GameBloc>(context);
          if (state is GameProgressUpdated) {
            final birdYaxis = state.birdYaxis;
            final barrierXOne = state.barrierXOne;
            final isStartGame = state.isStartGame;
            final barrierXTwo = state.barrierXTwo;
            final score = state.score;
            final bestScore = state.bestScore;
            return GestureDetector(
              onTap: () {
                isStartGame
                    ? _bloc.add(OnScreenTapped())
                    : _bloc.add(OnStartGame());
              },
              child: Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          MyBird(
                            birdYAxis: birdYaxis,
                          ),
                          // barrierXOne
                          MyBarrier(
                            barrierHeight: 180,
                            barrierXAxis: barrierXOne,
                            barrierYAxis: 1.1,
                          ),
                          //barrierXTwo
                          MyBarrier(
                            barrierHeight: 120,
                            barrierXAxis: barrierXTwo,
                            barrierYAxis: 1.1,
                          ),
                          Align(
                            alignment: Alignment(0.9, -0.85),
                            child: MyClouds(),
                          ),
                          //barrierXTwo
                          MyBarrier(
                            barrierHeight: 250,
                            barrierXAxis: barrierXTwo,
                            barrierYAxis: -1.1,
                          ),
                          //barrierXOne
                          MyBarrier(
                            barrierHeight: 180,
                            barrierXAxis: barrierXOne,
                            barrierYAxis: -1.1,
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
                                TwoLineWidget(
                                  title: "Score",
                                  subTitle: score.toString(),
                                ),
                                TwoLineWidget(
                                  title: "High Score",
                                  subTitle: bestScore.toString(),
                                ),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
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
          return SplashScreen();
        },
      ),
    );
  }

  showGameOverDialog(context) {
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
              Navigator.pop(context);
              _bloc.add(OnStartGame());
            },
            child: Text(
              "Play Again",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
