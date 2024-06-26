import 'package:json_annotation/json_annotation.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';

import '../models/tile.dart';

part 'gameData.g.dart';

enum GameStatus{init,playing,won,lost}

typedef Grid = List<Tile>;
typedef Indexes = List<int>;

@JsonSerializable(explicitToJson: true, anyMap: true)
class GameData {
  late Grid grid;
  late int score;
  late int bestScore;
  late GameStatus status;

  GameData(this.score, this.bestScore, this.grid,
      {this.status = GameStatus.init});

  GameData.newGame(this.bestScore,this.grid) : score = 0,
                                                status = GameStatus.playing;

  GameData copyWith({int? score,int? bestScore,Grid? grid,GameStatus? status}) =>
      GameData(score ?? this.score,
          bestScore ?? this.bestScore,
          grid ?? this.grid,
          status: status ?? this.status);

  //Create a Board from json data
  factory GameData.fromJson(Map<String, dynamic> json) => _$GameDataFromJson(json);

  //Generate json data from the Board
  Map<String, dynamic> toJson() => _$GameDataToJson(this);

}