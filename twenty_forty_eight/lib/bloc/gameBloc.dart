import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:twenty_forty_eight/model/tile.dart';

part 'gameEvent.dart';
part 'gameState.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(Initial() ) {
    on<Load>(_load);
    on<RestartGame>(_restartGame);
    on<LostGame>(_lostGame);
    on<WonGame>(_wonGame);
  }

  Iterable<Tile> get gridTiles => state.grid.expand((e) => e);
  List<List<Tile>> get gridCols => List.generate(4, (x) => List.generate(4, (y) => state.grid[y][x]) );

  //bool mergeLeft(AnimationController controller) => state.grid.map((e) => mergeTiles(e) ).toList().any((e) => e);
  //bool mergeRight(AnimationController controller) => state.grid.map((e) => mergeTiles(e.reversed.toList() ) ).toList().any((e) => e);
  //bool mergeUp(AnimationController controller) => gridCols.map((e) => mergeTiles(e) ).toList().any((e) => e);
  //bool mergeDown(AnimationController controller) => gridCols.map((e) => mergeTiles(e.reversed.toList() ) ).toList().any((e) => e);


  void _load(Load event,Emitter<GameState> emit) {
    emit(GameUpdate(grid: event.grid, score: event.score, bestScore: event.bestScore,status: event.status));
  }

  void randomTile() {
      List<Tile> empty = gridTiles.where((t) => t.value == 0).toList();

      if(state.status != GameStatus.playing) {
        return;
      }
      if(empty.isEmpty) {
        return;
      }

      final generator = Random();
      int value = generator.nextDouble() < 0.1 ? 4 : 2;

      empty.shuffle();

      empty.first.value = value;
  }

  void _restartGame(RestartGame event,Emitter<GameState> emit) {
    for(Tile t in gridTiles) {
      t.merged = false;
      t.nextX = null;
      t.nextY = null;
      t.value = 0;
    }

    emit(GameUpdate(grid: state.grid, score: 0, bestScore: state.bestScore,status: GameStatus.playing));
  }

  void _lostGame(LostGame event,Emitter<GameState> emit) {
    int bestScore = state.bestScore;

    if(event.score > bestScore) {
      bestScore = event.score;
    }

    emit(GameUpdate(grid: state.grid, score: event.score, bestScore: bestScore,status: GameStatus.lost) );

  }

  void _wonGame(WonGame event,Emitter<GameState> emit) {
    int bestScore = state.bestScore;

    if(event.score > bestScore) {
      bestScore = event.score;
    }

    emit(GameUpdate(grid: state.grid, score: event.score, bestScore: bestScore,status: GameStatus.won) );

  }

}