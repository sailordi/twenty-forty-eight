import 'dart:math';
import 'package:hive/hive.dart';
import './tile.dart';

part 'bord.g.dart'; // Hive generates this file

enum GameState { playing, won, lost }
const String boxName = "gameBox";
const int maxRandomTiles = 3;

@HiveType(typeId: 1)
class Game {
  @HiveField(0)
  List<List<Tile>> grid = [];

  @HiveField(1)
  int score = 0;

  @HiveField(2)
  int highScore = 0;

  @HiveField(3)
  GameState gameState = GameState.playing;

  Game();

  void save() {
    var box = Hive.box(boxName);

      box.put('grid', grid);
      box.put('score', score);
      box.put('highScore', highScore);
      box.put('gameState', gameState.index);
  }

  void load() {
    var box = Hive.box(boxName);

    grid = box.get('grid', defaultValue:[]);
    score = box.get('score', defaultValue: 0);
    highScore = box.get('highScore', defaultValue: 0);
    int gameStateIndex = box.get('gameState', defaultValue: GameState.playing.index);

    gameState = _stateFromIndex(gameStateIndex);

    if(grid.isEmpty == true) {
      var rng = Random();

      for(int i = 0; i < 4; i++) {
        List<Tile> l = [];
        for(int j = 0; j < 4; j++) {
          l.add(Tile(0,i,j) );
        }
        grid.add(l);
      }

      int times = rng.nextInt(maxRandomTiles)+1;
      List<(int,int)> indexes = [];

      for(int i = 0; i < times; i++) {
        Tile t = randomTile(indexes);
        grid[t.x][t.y].value = t.value;
      }

    }

  }

  Tile randomTile(List<(int,int)> indexes) {
    var i = 0;
    var j = 0;
    var rng = Random();

    do {
      i = rng.nextInt(4);
      j = rng.nextInt(4);

      if(!indexes.contains((i,j) ) ) {
        indexes.add((i,j) );
      }

    } while (indexes.contains((i,j) ));

    return Tile(2,i,j);
  }

  GameState _stateFromIndex(int index) {
    switch(index) {
      case 0: return GameState.playing;
      case 1: return GameState.won;
      default: return GameState.lost;
    }

  }

}