part of 'game_bloc.dart';

@immutable
sealed class GameEvent {}

class StartNewGame extends GameEvent {}

class MakeMove extends GameEvent {
  final SwipeDirection direction; // Enum for direction of the move
  MakeMove(this.direction);
}

class SaveGame extends GameEvent {}

class LoadGame extends GameEvent {}