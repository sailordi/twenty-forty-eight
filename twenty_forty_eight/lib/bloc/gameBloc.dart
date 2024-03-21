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
  Iterable<Tile> get allTiles => [gridTiles,state.toAdd].expand((e) => e);
  List<List<Tile>> get gridCols => List.generate(4, (x) => List.generate(4, (y) => state.grid[y][x]) );

  void addNewTiles(List<int> values,AnimationController controller) {
    List<Tile> empty = gridTiles.where((t) => t.value == 0).toList();
    empty.shuffle();
    for (int i = 0; i < values.length; i++) {
      state.toAdd.add(Tile(empty[i].x, empty[i].y, values[i])..appear(controller) );
    }

  }

  bool mergeLeft(AnimationController controller) => state.grid.map((e) => mergeTiles(e,controller) ).toList().any((e) => e);
  bool mergeRight(AnimationController controller) => state.grid.map((e) => mergeTiles(e.reversed.toList(),controller) ).toList().any((e) => e);
  bool mergeUp(AnimationController controller) => gridCols.map((e) => mergeTiles(e,controller) ).toList().any((e) => e);
  bool mergeDown(AnimationController controller) => gridCols.map((e) => mergeTiles(e.reversed.toList(),controller) ).toList().any((e) => e);
  bool mergeTiles(List<Tile> tiles,AnimationController controller) {
    bool didChange = false;
    int s = state.score;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[j].value != 0) {
          Tile? mergeTile = tiles.skip(j + 1).firstWhereOrNull( (t) => t.value != 0);

          if (mergeTile != null && mergeTile.value == tiles[j].value) {
            // If a merge is possible, update didChange and perform the merge.
            didChange = true;
            int resultValue = tiles[j].value * 2; // Assuming a merge doubles the tile's value.
            s += tiles[j].value;

            // Update game state, animations, and possibly score here.
            tiles[j].moveTo(controller, tiles[i].x, tiles[i].y); // Adapt moveTo method for your use.
            mergeTile.moveTo(controller, tiles[i].x, tiles[i].y); // Same as above.
            // Consider adding score update logic here.

            mergeTile.value = 0;
            tiles[j].value = resultValue;
          }
          break; // Exit the loop after finding the first non-zero tile to consider for merging.
        }
      }
    }

    if(didChange) {
      GameState(grid: state.grid,score: s,bestScore: state.bestScore,status: state.status);
    }

    return didChange;
  }

  void _load(Load event,Emitter<GameState> emit) {
    emit(GameUpdate(grid: event.grid, score: event.score, bestScore: event.bestScore,status: event.status));
  }

  void _restartGame(RestartGame event,Emitter<GameState> emit) {
    List<List<Tile> > grid = List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0) ) );

    emit(GameUpdate(grid: grid, score: 0, bestScore: state.bestScore,status: GameStatus.playing));
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