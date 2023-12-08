part of 'game_bloc.dart';

@immutable
sealed class GameState {
  final List<List<Tile> > grid;
  final int score;
  final int bestScore;
  final bool lost;
  final bool init;
  
  const GameState({required this.grid,required this.score,required this.bestScore,required this.lost,required this.init});
}

final class GameInitial extends GameState {
  GameInitial(): super(grid:[], score: 0,bestScore: 0,lost: false,init: false) {
    for(int i = 0; i < 4;i++) {
      List<Tile> c = [];
      for(int j = 0; j < 4;j++) {
        c.add(Tile() );
      }
      grid.add(c);
    }
  }
}

final class GameUpdate extends GameState {
  const GameUpdate({required List<List<Tile> > grid,required int score,required int bestScore,required bool lost,required bool init}):
            super(grid: grid,score: score,bestScore: bestScore,lost:lost,init: init);
}