part of 'gameBloc.dart';

enum GameStatus{init,playing,won,lost}

class GameState {
  late List<List<Tile> > grid;
  final int score;
  final int bestScore;
  final GameStatus status;

  GameState({required this.grid,required this.score,required this.bestScore,required this.status});

  Map<String, dynamic> toJson() => {
    'grid': grid.map((row) => row.map((tile) => tile.toJson()).toList()).toList(),
    'score': score,
    'bestScore': bestScore,
    'status': status.index, //
  };

  static GameState fromJson(Map<String, dynamic> json) => GameUpdate(
    grid: (json['grid'] as List)
        .map((row) => (row as List)
        .map((tileJson) => Tile.fromJson(tileJson as Map<String, dynamic>))
        .toList())
        .toList(),
    score: json['score'] as int,
    bestScore: json['bestScore'] as int,
    status: GameStatus.values[json['status'] as int],
  );

}

final class Initial extends GameState {
  Initial(): super(grid:[], score: 0,bestScore: 0,status: GameStatus.init) {
    grid = List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, value: 0) ) );
  }

}

final class GameUpdate extends GameState {
  GameUpdate({required super.grid,required super.score,required super.bestScore,required super.status});

}


