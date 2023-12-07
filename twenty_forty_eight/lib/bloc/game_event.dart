part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}

class RestartGameEvent extends GameEvent {}

class LostGameEvent extends GameEvent {}

class MoveLeftEvent extends GameEvent {
  final int row;

  MoveLeftEvent({required this.row});
}

class MoveRightEvent extends GameEvent {
  final int row;

  MoveRightEvent({required this.row});
}

class MoveUpEvent extends GameEvent {
  final int column;

  MoveUpEvent({required this.column});
}

class MoveDownEvent extends GameEvent {
  final int column;

  MoveDownEvent({required this.column});
}