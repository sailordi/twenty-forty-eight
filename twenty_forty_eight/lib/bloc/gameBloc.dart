import 'package:bloc/bloc.dart';
import '../model/Tile.dart';

part 'gameEvent.dart';
part 'gameState.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(Initial() ) {
    on<Initialised>(_gridInitialised);
    on<RestartGame>(_restartGame);
    on<LostGame>(_lostGame);
    on<WonGame>(_wonGame);
  }

  void _gridInitialised(Initialised event,Emitter<GameState> emit) {
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