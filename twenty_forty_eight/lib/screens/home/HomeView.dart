import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_bloc.dart';
import 'package:twenty_forty_eight/widgets/WidgetFactory.dart';
import 'package:twenty_forty_eight/model/GameInfo.dart';
import 'package:twenty_forty_eight/model/Grid.dart';
import 'package:twenty_forty_eight/model/Tile.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  void _initGrid(GameState state) {
    if(state.status != GameStatus.none) {
      return;
    }
    Grid grid = state.grid;
    final generator = Random();

    for(int i = 0; i < generator.nextInt(3) + 1; i++) {
      grid.randomTile();
    }

    BlocProvider.of<GameBloc>(context).add(GridInitialised(grid: grid) );
  }

  void _newGame(GameState state) {
    BlocProvider.of<GameBloc>(context).add(RestartGameEvent() );
    _initGrid(state);
  }

  @override
  Widget build(BuildContext context) {
    final info = GameInfo(context);
    return Scaffold(
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          _initGrid(state);
          return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      WidgetFactory.logo(),
                      WidgetFactory.scoreBord(state.score,state.bestScore)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      WidgetFactory.instructions(),
                      WidgetFactory.newGame(() { _newGame(state); })
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      WidgetFactory.emptyBoard(info.width,info.height),
                      ...List.generate(state.grid.tiles.length, (i) {
                        Tile t = state.grid.tiles[i];
                       return Positioned(
                          key: ValueKey(t.id),
                          top: t.getTop(info.tileSize),
                          left: t.getLeft(info.tileSize),
                          child: t.widget(info.tileSize,info.tileSize),
                        );
                      })
                    ],
                  ),
                ],
              )
            );
        }
      )
    );
  }

}
