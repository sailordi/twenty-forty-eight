import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../model/Tile.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial() ) {
    on<GridInitialised>(_gridInitialised);
    on<RestartGameEvent>(_restartGame);
    on<LostGameEvent>(_lostGame);
    on<MoveUpEvent>(_moveTileUp);
    on<MoveDownEvent>(_moveTileDown);
    on<MoveLeftEvent>(_moveTileLeft);
    on<MoveRightEvent>(_moveTileRight);
  }

  void _gridInitialised(GridInitialised event,Emitter<GameState> emit) {
    emit(GameUpdate(grid: event.grid, score: 0, bestScore: state.bestScore,lost: false,init: true));
  }

  void _restartGame(RestartGameEvent event,Emitter<GameState> emit) {
    List<List<Tile> > grid = [];
    for(int i = 0; i < 4;i++) {
      List<Tile> c = [];
      for(int j = 0; j < 4;j++) {
        c.add(Tile() );
      }
      grid.add(c);
    }

    emit(GameUpdate(grid: grid, score: 0, bestScore: state.bestScore,lost: false,init: false));
  }

  void _lostGame(LostGameEvent event,Emitter<GameState> emit) {
    int bestScore = state.bestScore;

    if(state.score > bestScore) {
      bestScore = state.score;
    }

    emit(GameUpdate(grid: const [], score: state.score, bestScore: bestScore,lost: true,init: state.init));

  }

  void _moveTileUp(MoveUpEvent event,Emitter<GameState> emit) {
    if(state.lost) {
      return;
    }

    int column = event.column;
    int score = state.score;
    List<List<Tile> > g = state.grid;
    List<Tile> col = [];

    // Update each column in the specified row
    for (int i = 0; i < g.length; i++) {
      col.add(g[i][column]);
    }

    (col,score) = _mergeRow(col,score);

    for (int i = 0; i < g.length; i++) {
      g[i][column] = col[i];
    }

    emit(GameUpdate(grid: g, score: score, bestScore: state.bestScore,lost: state.lost,init: state.init));
  }

  void _moveTileDown(MoveDownEvent event,Emitter<GameState> emit) {
    if(state.lost) {
      return;
    }

    int column = event.column;
    int score = state.score;
    List<List<Tile> > g = state.grid;
    List<Tile> col = [];

    // Reverse the column, update, and reverse it back
    for (int i = g.length - 1; i >= 0; i--) {
      col.add(g[i][column]);
    }

    (col,score) = _mergeRow(col,score);

    for (int i = g.length - 1; i >= 0; i--) {
      g[i][column] = col[i];
    }

    emit(GameUpdate(grid: g, score: score, bestScore: state.bestScore,lost: state.lost,init: state.init));
  }

  void _moveTileLeft(MoveLeftEvent event,Emitter<GameState> emit) {
    if(state.lost) {
      return;
    }

    int row = event.row;
    int score = state.score;
    List<List<Tile> > g = state.grid;
    List<Tile> r = g[row];

    (r,score) = _mergeRow(r,score);

    g[row] = r;

    emit(GameUpdate(grid: g, score: score, bestScore: state.bestScore,lost: state.lost,init: state.init) );
  }

  void _moveTileRight(MoveRightEvent event,Emitter<GameState> emit) {
    if (state.lost) {
      return;
    }

    int row = event.row;
    int score = state.score;
    List<List<Tile> > g = state.grid;
    List<Tile> r = g[row].reversed.toList();

    (r,score) = _mergeRow(r,score);

    g[row] = r.reversed.toList();

    emit(GameUpdate(grid: g, score: score, bestScore: state.bestScore,lost: state.lost,init: state.init) );
  }

  (List<Tile>,int) _mergeRow(List<Tile> row,int score) {
    List<Tile> mergedRow = [];

    for (int i = 0; i < row.length; i++) {
      if (row[i].value != 0) {
        if (i < row.length - 1 && row[i].value == row[i + 1].value) {
          // Merge tiles if they have the same value
          int mergedValue = row[i].value * 2;
          // Update score for merged tiles
          score += mergedValue;
          // Check if value is max value
          mergedRow.add(Tile(value: mergedValue == 2048 ? 0 : mergedValue) );
          // Skip the next tile
          i++;
          //Next tile empty
          mergedRow.add(Tile(value: 0) );
        } else {
          // Keep the tile as it is
          mergedRow.add(Tile(value: row[i].value));
        }
      }
    }

    return (mergedRow,score);
  }

}
