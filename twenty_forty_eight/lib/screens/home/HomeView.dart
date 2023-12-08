import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_bloc.dart';
import 'package:twenty_forty_eight/model/Tile.dart';
import 'package:twenty_forty_eight/widgets/WidgetFactory.dart';
import 'package:twenty_forty_eight/model/GameInfo.dart';

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
    if(!state.init) {
      List<List<Tile> > grid = state.grid;
      final generator = Random();

      for(int i = 0; i < generator.nextInt(3) + 1; i++) {
        _randomTile(grid);
      }

      BlocProvider.of<GameBloc>(context).add(GridInitialised(grid: grid) );
    }
  }

  void _newGame(GameState state) {
    BlocProvider.of<GameBloc>(context).add(RestartGameEvent() );
    _initGrid(state);
  }

  void _randomTile(List<List<Tile> > grid) {
    int i,j;
    final generator = Random();

    do {
      i = generator.nextInt(4);
      j = generator.nextInt(4);
    } while (grid[i][j].value != 0);

    int value = generator.nextDouble() < 0.1 ? 4 : 2;

    grid[i][j].value = value;

  }

  @override
  Widget build(BuildContext context) {
    final info = GameInfo(context);
    return Scaffold(
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          _initGrid(state);
          return Column(
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
                  WidgetFactory.newGame(() { _newGame(state); })
                ],
              ),
              const SizedBox(height: 5),
              Stack(
                children: [
                  WidgetFactory.emptyBoard(info.width,info.height),
                  for (int i = 0; i < state.grid.length; ++i)
                    for (int j = 0; j < state.grid[i].length; ++j)
                      Positioned(
                        top: (i + 1) * info.spaceBetweenTiles + i * info.tileSize-6,
                        left: (j + 1) * info.spaceBetweenTiles + j * info.tileSize-6,
                        child: state.grid[i][j].widget(info.tileSize,info.tileSize)
                      ),
                ],
              )
            ],
          );
        }
      )
    );
  }

}
