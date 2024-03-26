part of 'gameBloc.dart';

sealed class GameEvent {}

class RestartGame extends GameEvent {}

class NewTile extends GameEvent {}

class LostGame extends GameEvent {
  final int score;

  LostGame({required this.score});

}

class WonGame extends GameEvent {
  final int score;

  WonGame({required this.score});

}

class Load extends GameEvent {
  final List<List<Tile> > grid;
  final int score;
  final int bestScore;
  final GameStatus status;

  Load({required this.grid,required this.score,required this.bestScore,required this.status});
}


