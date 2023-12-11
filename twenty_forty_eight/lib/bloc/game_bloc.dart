import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:twenty_forty_eight/model/GameInfo.dart';
import '../model/Tile.dart';
import '../model/Grid.dart';

part 'game_event.dart';
part 'game_state.dart';

enum GameStatus{none,playing,won,lost}

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial() ) {
    on<GridInitialised>(_gridInitialised);
    on<RestartGameEvent>(_restartGame);
    on<LostGameEvent>(_lostGame);
    on<WonGameEvent>(_wonGame);
    on<UpdateGame>(_updateGame);

  }

  void _gridInitialised(GridInitialised event,Emitter<GameState> emit) {
    emit(GameUpdate(grid: event.grid, score: 0, bestScore: state.bestScore,
        status: GameStatus.playing) );
  }

  void _restartGame(RestartGameEvent event,Emitter<GameState> emit) {
    state.grid.resetGrid();

    emit(GameUpdate(grid: state.grid, score: 0, bestScore: state.bestScore,status: GameStatus.none) );
  }

  void _lostGame(LostGameEvent event,Emitter<GameState> emit) {
    int bestScore = state.bestScore;

    if(state.score > bestScore) {
      bestScore = state.score;
    }

    emit(GameUpdate(grid: state.grid, score: state.score, bestScore: bestScore,status: GameStatus.lost));

  }

  void _wonGame(WonGameEvent event,Emitter<GameState> emit) {
    int bestScore = state.bestScore;

    if(state.score > bestScore) {
      bestScore = state.score;
    }

    emit(GameUpdate(grid: state.grid, score: state.score, bestScore: bestScore,status: GameStatus.won));

  }

  void _updateGame(UpdateGame event,Emitter<GameState> emit) {
    emit(GameUpdate(grid: event.grid, score: event.score, bestScore: state.bestScore,status: state.status));
  }

  }