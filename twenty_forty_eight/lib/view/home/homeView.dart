import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:twenty_forty_eight/models/gameData.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';
import 'package:twenty_forty_eight/widgets/boardWidget.dart';
import 'package:twenty_forty_eight/widgets/buttonWidget.dart';
import 'package:twenty_forty_eight/widgets/scoreWidget.dart';
import 'package:twenty_forty_eight/widgets/widgetFactory.dart';

import '../../managers/boardManager.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeView> with TickerProviderStateMixin, WidgetsBindingObserver {
  //The contoller used to move the the tiles
  late final AnimationController _moveController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..addStatusListener((status) {
    //When the movement finishes merge the tiles and start the scale animation which gives the pop effect.
    if (status == AnimationStatus.completed) {
        ref.read(boardManager.notifier).merge();
        _scaleController.forward(from: 0.0);
    }
  });

  //The curve animation for the move animation controller.
  late final CurvedAnimation _moveAnimation = CurvedAnimation(
    parent: _moveController,
    curve: Curves.easeInOut,
  );

  //The contoller used to show a popup effect when the tiles get merged
  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..addStatusListener((status) {
    //When the scale animation finishes end the round and if there is a queued movement start the move controller again for the next direction.
    if (status == AnimationStatus.completed) {
      if (ref.read(boardManager.notifier).endRound() ) {
        _moveController.forward(from: 0.0);
      }
    }
  });

  //The curve animation for the scale animation controller.
  late final CurvedAnimation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    //Add an Observer for the Lifecycles of the App
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    //Remove the Observer for the Lifecycles of the App
    WidgetsBinding.instance.removeObserver(this);

    //Dispose the animations.
    _moveAnimation.dispose();
    _scaleAnimation.dispose();
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //Save current state when the app becomes inactive
    if (state == AppLifecycleState.inactive) {
      ref.read(boardManager.notifier).save();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    GameInfo info = GameInfo(context);
    const double space = 50.0;

    return SwipeDetector(
      onSwipe: (direction, offset) {
        if (ref.read(boardManager.notifier).move(direction)) {
          _moveController.forward(from: 0.0);
        }
      },
      child: Scaffold(
        backgroundColor: GameInfo.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: space,),
              Stack(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10,),
                        WidgetFactory.logo(),
                      ]
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ScoreWidget(),
                      SizedBox(width: 10,),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10,),
                  WidgetFactory.instructions()
                ],
              ),
              const SizedBox(height: 10,),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10,),
                      ButtonWidget(
                        text: "New game",
                        onPressed: () {
                          //Restart the game
                          ref.read(boardManager.notifier).newGame();
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10,),
                      NewLineTextButtonWidget(
                        text: "New Game\n+\nReset best",
                        onPressed: () {
                          //Resets best score
                          ref.read(boardManager.notifier).resetBestScore();
                        },
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: space),
              Stack(
                children: [
                  EmptyBordWidget(info: info),
                  TileBoardWidget(
                    moveAnimation: _moveAnimation,
                    scaleAnimation: _scaleAnimation, info: info,)
                ],
              )
            ],
          )
        ),
      ),
    );
  }

}