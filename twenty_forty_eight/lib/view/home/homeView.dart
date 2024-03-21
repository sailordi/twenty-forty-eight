import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/model/tile.dart';
import 'package:twenty_forty_eight/model/gameInfo.dart';
import 'package:twenty_forty_eight/bloc/gameBloc.dart';
import 'package:twenty_forty_eight/widgets/bigButton.dart';
import 'package:twenty_forty_eight/widgets/swipeWidget.dart';
import 'package:twenty_forty_eight/widgets/tileWidget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver,SingleTickerProviderStateMixin {
  late AnimationController controller;
  late GameBloc b;
  late GameInfo info;

  late Timer aiTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    b = BlocProvider.of<GameBloc>(context);
    info = GameInfo(context);

    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          for (var e in b.state.toAdd) {
            b.state.grid[e.y][e.x].value = e.value;
          }
          for (var t in b.gridTiles) {
            t.resetAnimations();
          }
          b.state.toAdd.clear();
        });
      }
    });

    loadGameState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      saveGameState(b.state);
    }

  }

  void saveGameState(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();
    String gameStateJson = json.encode(gameState.toJson());

      await prefs.setString('gameState', gameStateJson);
  }

  void loadGameState() async {
    final prefs = await SharedPreferences.getInstance();

    String? gameStateJson = prefs.getString('gameState');

    if(gameStateJson != null) {
      Map<String, dynamic> jsonDecode = json.decode(gameStateJson);

      List<List<Tile> > grid = (jsonDecode['grid'] as List)
          .map((row) => (row as List)
          .map((tileJson) => Tile.fromJson(tileJson as Map<String, dynamic>))
          .toList())
          .toList();
      int score = jsonDecode['score'] as int;
      int bestScore = jsonDecode['score'] as int;
      GameStatus status = GameStatus.values[jsonDecode['status'] as int];

      setState(() {
        b.add(Load(grid: grid,score: score,bestScore:bestScore,status:status) );
      });

    }

  }

  void _newGame(GameState state) {
    setState(() {
      b.add(RestartGame() );
    });

  }

  void merge(SwipeDirection direction) {
    bool Function(AnimationController controller) mergeFn;
    switch (direction) {
      case SwipeDirection.up:
        mergeFn = b.mergeUp;
        break;
      case SwipeDirection.down:
        mergeFn = b.mergeDown;
        break;
      case SwipeDirection.left:
        mergeFn = b.mergeLeft;
        break;
      case SwipeDirection.right:
        mergeFn = b.mergeRight;
        break;
    }
    setState(() {
      if (mergeFn(controller) ) {
        final generator = Random();

        int value = generator.nextDouble() < 0.1 ? 4 : 2;

        b.addNewTiles([value],controller);

        controller.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackItems = [];
    stackItems.addAll(b.gridTiles.map((tile) => TileWidget(tile,info,false)) );
    stackItems.addAll(b.allTiles.map( (tile) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) => tile.animatedValue.value == 0
            ? const SizedBox()
            : TileWidget(tile,info,true,
            child: Center(child: TileNumber(tile.animatedValue.value) ) ) ) ) );

    return Scaffold(
        backgroundColor: GameInfo.tan,
        body: Padding(
            padding: EdgeInsets.all(GameInfo.contentPadding),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SwipeWidget(
                  up: () => merge(SwipeDirection.up),
                  down: () => merge(SwipeDirection.down),
                  left: () => merge(SwipeDirection.left),
                  right: () => merge(SwipeDirection.right),
                  child: Container(
                      height: info.gridSize,
                      width: info.gridSize,
                      padding: EdgeInsets.all(GameInfo.borderSize),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(GameInfo.cornerRadius), color: GameInfo.darkBrown),
                      child: Stack(
                        children: stackItems,
                      ))),
              BigButton(label: "Restart", color: GameInfo.orange, onPressed: () {_newGame(b.state); } ),
            ]
            )
        )
    );
  }

}