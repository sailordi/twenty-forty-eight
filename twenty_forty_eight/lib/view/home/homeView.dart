import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/models/tile.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';
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
  late GameInfo info;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _saveGameState(provider(context).state);
    }

  }

  void _saveGameState(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();
    String gameStateJson = json.encode(gameState.toJson());

      await prefs.setString('gameState',"");//gameStateJson);
  }

  Future<(GameState,bool)> _loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    GameState ret = GameState(grid: [],score: 0,bestScore: 0,status: GameStatus.init);
    bool loaded = false;

    String? gameStateJson ;//= prefs.getString('gameState');

    if(gameStateJson != null) {
      loaded = true;
      Map<String, dynamic> jsonDecode = json.decode(gameStateJson);

      ret = GameState.fromJson(jsonDecode);
    }

    return (ret,loaded);
  }

  void _initGrid(GameBloc bloc,GameState state) async {
    if(state.status != GameStatus.init) {
      return;
    }
    (GameState,bool) data = await _loadGameState();

    if(data.$2 == true) {
      bloc.add(Load(grid: data.$1.grid, score: data.$1.score, bestScore: data.$1.bestScore, status: data.$1.status) );
    }
    else {
      bloc.add(RestartGame() );
    }

  }

  void _newGame(BuildContext context) {
    provider(context).add(RestartGame() );
  }

  GameBloc provider(BuildContext context) {
    return BlocProvider.of<GameBloc>(context);
  }

  void merge(SwipeDirection direction) {
  }

  @override
  Widget build(BuildContext context) {
    info = GameInfo(context);

    return Scaffold(
        backgroundColor: GameInfo.tan,
        body: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              _initGrid(provider(context),state);
              return   Column(
                children: [
                  Stack(
                    children: [
                      WidgetFactory.logo(),
                      WidgetFactory.scoreBord(state.score,state.bestScore)
                    ],
                  ),
                  Stack(
                    children: [
                      WidgetFactory.instructions(),
                      WidgetFactory.newGame(() { _newGame(context); })
                    ],
                  ),
                  const SizedBox(height: 5),
                  Stack(
                      children: [
                        WidgetFactory.emptyBoard(info.width,info.height),
                        for (int i = 0; i < state.grid.length; ++i)
                          for (int j = 0; j < state.grid[i].length; ++j)
                            Positioned(
                                top: (i + 1) * GameInfo.spaceBetweenTiles + i * info.tileSize-6,
                                left: (j + 1) * GameInfo.spaceBetweenTiles + j * info.tileSize-6,
                                child: state.grid[i][j].widget(info.tileSize,info.tileSize)
                            ),
                      ]
                  )
                ],
              );
            }
        )
    );
  }

}