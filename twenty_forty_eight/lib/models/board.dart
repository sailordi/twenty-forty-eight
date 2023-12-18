import 'package:json_annotation/json_annotation.dart';
import '../models/tile.dart';

part 'board.g.dart';

enum GameStatus{playing,won,lost}

const Map<String,GameStatus> stringStatus = {"playing":GameStatus.playing,
  "won":GameStatus.won,
  "lost":GameStatus.lost
};

const Map<GameStatus,String> statusString = {GameStatus.playing:"playing",
  GameStatus.won:"won",
  GameStatus.lost:"lost"
};


@JsonSerializable(explicitToJson: true, anyMap: true)
class Board {
  final int score;
  final int bestScore;
  final List<Tile> tiles;
  final GameStatus status;

  Board(this.score,this.bestScore,this.tiles,{this.status = GameStatus.playing} );

  Board.newGame(this.bestScore,this.tiles) : score = 0,
                                            status = GameStatus.playing;
  //Create an immutable copy of the board
  Board copyWith(
      {int? score,
        int? bestScore,
        List<Tile>? tiles,
        GameStatus? status}) =>
      Board(score ?? this.score, bestScore ?? this.bestScore, tiles ?? this.tiles,
          status: status ?? this.status);


  //Create a Board from json data
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  //Generate json data from the Board
  Map<String, dynamic> toJson() => _$BoardToJson(this);

}