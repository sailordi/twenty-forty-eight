part of 'game_bloc.dart';

@immutable
sealed class GameState {
  final List<List<Tile> > grid;
  final int score;
  final int bestScore;
  final bool lost;
  
  const GameState({required this.grid,required this.score,required this.bestScore,required this.lost});
}

final class GameInitial extends GameState {
  GameInitial(): super(grid: [],score: 0,bestScore: 0,lost: false);
}

final class GameUpdate extends GameState {
  const GameUpdate({required List<List<Tile> > grid,required int score,required int bestScore,required bool lost}):
            super(grid: grid,score: score,bestScore: bestScore,lost:lost);
}