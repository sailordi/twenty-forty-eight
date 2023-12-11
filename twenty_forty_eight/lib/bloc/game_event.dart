part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}

class RestartGameEvent extends GameEvent {}

class LostGameEvent extends GameEvent {}

class WonGameEvent extends GameEvent {}

class GridInitialised extends GameEvent {
  final Grid grid;

  GridInitialised({required this.grid});
}

class UpdateGame extends GameEvent {
  final Grid grid;
  final int score;

  UpdateGame({required this.score,required this.grid});
}
