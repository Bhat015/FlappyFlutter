import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Event
abstract class GameEvent {}

class OnInitialiseGame extends GameEvent {}

class OnStartGame extends GameEvent {}

class OnScreenTapped extends GameEvent {}

class OnUpdateGameProgress extends GameEvent {}

//State
abstract class GameState {}

class ShowSPlashScreen extends GameState {}

class GameProgressUpdated extends GameState {
  final double birdYaxis;
  final double barrierXOne;
  final bool isStartGame;
  final bool isBarrierTouched;
  final double barrierXTwo;
  final int score;
  final int bestScore;

  GameProgressUpdated(
      {this.birdYaxis = 0,
      this.barrierXOne = 0,
      this.isStartGame = false,
      this.isBarrierTouched = false,
      this.barrierXTwo = 0,
      this.score = 0,
      this.bestScore = 0});
}

//Bloc
class GameBloc extends Bloc<GameEvent, GameState> {
  double time = 0;
  double height = 0;
  double initialHeight = 0;
  bool isStartGame = false;
  bool isBarrierTouched = false;
  double birdYaxis = 0;
  double barrierXOne = 0;
  double barrierXTwo = 0;
  int score = 0;
  int bestScore = 0;
  late SharedPreferences pref;

  GameBloc() : super(ShowSPlashScreen());

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is OnInitialiseGame) {
      pref = await SharedPreferences.getInstance();
      bestScore = pref.getInt("HighScore") ?? 0;
      await Future.delayed(Duration(seconds: 2));

      barrierXOne = 0.9;
      barrierXTwo = barrierXOne + 1.8;

      yield GameProgressUpdated(
        barrierXOne: barrierXOne,
        barrierXTwo: barrierXTwo,
        bestScore: bestScore,
      );
    }

    if (event is OnStartGame) {
      time = 0;
      height = 0;
      initialHeight = 0;
      isStartGame = false;
      score = 0;
      barrierXOne = 0.9;
      barrierXTwo = barrierXOne + 1.8;
      isBarrierTouched = false;
      startGame();
    }

    if (event is OnScreenTapped) {
      // new parabolic function starting from time 0
      // and initial height from current bird height
      time = 0;
      initialHeight = birdYaxis;
    }

    if (event is OnUpdateGameProgress) {
      yield GameProgressUpdated(
        barrierXOne: barrierXOne,
        barrierXTwo: barrierXTwo,
        bestScore: bestScore,
        birdYaxis: birdYaxis,
        isBarrierTouched: isBarrierTouched,
        isStartGame: isStartGame,
        score: score,
      );
    }
  }

  void startGame() {
    isStartGame = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) async {
      time = time + 0.04;

      // Parabolic function
      // yaxis = height = (-g(t)^2 )/ 2 + vt
      // considering g as 9.8 and v as 2.8
      height = (-4.9 * (time * time)) + 2.8 * time;

      // moving the bird
      birdYaxis = initialHeight - height;

      // moving barrier one
      if (barrierXOne < -2) {
        barrierXOne += 3.5;
      } else {
        barrierXOne -= 0.05;
      }
      // moving barrier two
      if (barrierXTwo < -2) {
        barrierXTwo += 3.5;
      } else {
        barrierXTwo -= 0.05;
      }
      // update score
      if (barrierXOne < -0.75 && barrierXOne > -0.79) {
        score += 1;
      }
      if (barrierXTwo < -0.74 && barrierXTwo > -0.78) {
        score += 1;
      }

      // check collision
      if (barrierXOne < -0.20 && barrierXOne > -0.75) {
        if (birdYaxis < -0.33 || birdYaxis > 0.35) {
          isBarrierTouched = true;
        }
      }
      if (barrierXTwo < -0.19 && barrierXTwo > -0.74) {
        if (birdYaxis < -0.005 || birdYaxis > 0.65) {
          isBarrierTouched = true;
        }
      }

      if (birdYaxis >= 1 || isBarrierTouched) {
        timer.cancel();
        isStartGame = false;
        bestScore = score > bestScore ? score : bestScore;
        await pref.setInt("HighScore", bestScore);
      }
      add(OnUpdateGameProgress());
    });
  }
}
