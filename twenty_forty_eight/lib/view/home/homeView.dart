import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/model/tile.dart';
import 'package:twenty_forty_eight/model/gameInfo.dart';
import 'package:twenty_forty_eight/bloc/gameBloc.dart';
import 'package:twenty_forty_eight/widgets/swipeWidget.dart';
import 'package:twenty_forty_eight/widgets/tileWidget.dart';
import 'package:twenty_forty_eight/widgets/widgetFactory.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver,SingleTickerProviderStateMixin {
  late GameBloc b;
  late GameInfo info;
  bool init = false;

  late Timer aiTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        info = GameInfo(context);
        b = BlocProvider.of<GameBloc>(context);
      });

      _loadGameState();

      setState(() {
        init = true;
      });

    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _saveGameState(b.state);
    }

  }

  void _saveGameState(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();
    String gameStateJson = json.encode(gameState.toJson());

      await prefs.setString('gameState',"");//gameStateJson);
  }

  void _loadGameState() async {
    final prefs = await SharedPreferences.getInstance();

    String? gameStateJson ;//= prefs.getString('gameState');

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

      b.add(Load(grid: grid,score: score,bestScore:bestScore,status:status) );
    } else {
      _newGame();
    }

  }

  void _newGame() {
    b.add(RestartGame() );

    final generator = Random();
    int tiles = generator.nextInt(4) + 3;

    for(int i = 0; i < tiles; i++) {
      b.randomTile();
    }

  }

  void merge(SwipeDirection direction) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GameInfo.tan,
        body: Column(
          children: [
            Stack(
              children: [
                WidgetFactory.logo(),
                WidgetFactory.scoreBord(b.state.score,b.state.bestScore)
              ],
            ),
            Stack(
              children: [
                WidgetFactory.instructions(),
                WidgetFactory.newGame(() { _newGame(); })
              ],
            ),
            const SizedBox(height: 5),
            Stack(
            children: [
              WidgetFactory.emptyBoard(info.width,info.height),
              for (int i = 0; i < b.state.grid.length; ++i)
                for (int j = 0; j < b.state.grid[i].length; ++j)
                  Positioned(
                      top: (i + 1) * GameInfo.spaceBetweenTiles + i * info.tileSize-6,
                      left: (j + 1) * GameInfo.spaceBetweenTiles + j * info.tileSize-6,
                      child: b.state.grid[i][j].widget(info.tileSize,info.tileSize)
                  ),
            ]
            )
          ],
        ),
    );
  }

}