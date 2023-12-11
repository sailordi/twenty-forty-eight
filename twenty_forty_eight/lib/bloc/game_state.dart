part of 'game_bloc.dart';

@immutable
sealed class GameState {
  final Grid grid;
  final int score;
  final int bestScore;
  final GameStatus status;
  
  const GameState({required this.grid,required this.score,
                    required this.bestScore,required this.status});

}

final class GameInitial extends GameState {
  GameInitial(): super(grid:Grid(), score: 0,bestScore: 0,status: GameStatus.none);
}

final class GameUpdate extends GameState {
  const GameUpdate({required Grid grid,required int score,required int bestScore,required GameStatus status}):
            super(grid: grid,score: score,bestScore: bestScore,status: status);
}