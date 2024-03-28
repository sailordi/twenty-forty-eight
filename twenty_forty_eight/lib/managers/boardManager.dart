import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';

import '../models/tile.dart';
import '../models/gameData.dart';

import 'nextDirectionManager.dart';
import 'roundManager.dart';


class BoardManager extends StateNotifier<GameData> {
  final StateNotifierProviderRef ref;
  final String hiveName = 'gameData';

  BoardManager(this.ref) : super(GameData.newGame(0, [])) {
    //Load the last saved state or start a new game.
    load();
  }

  void load() async {
    //Access the box and get the first item at index 0
    //which will always be just one item of the Board model
    //and here we don't need to call fromJson function of the board model
    //in order to construct the Board model
    //instead the adapter we added earlier will do that automatically.
    var box = await Hive.openBox<GameData>(hiveName);
    //If there is no save locally it will start a new game.
    state = box.get(0) ?? _restart();
  }

  void save() async {
    //Here we don't need to call toJson function of the board model
    //in order to convert the data to json
    //instead the adapter we added earlier will do that automatically.
    var box = await Hive.openBox<GameData>(hiveName);
    try {
      box.putAt(0, state);
    } catch (e) {
      box.add(state);
    }
  }

  // Create a fresh game state.
  GameData _restart() {
      Random gen = Random();
      int tiles = 0;
      List<(int,int)> xy = [];
      List<List<Tile> > grid = state.grid;

      while(tiles < 3) {
        tiles = gen.nextInt(2) + 3;
      }

      if(grid.isEmpty) {
        grid = List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, value: 0) ) );
      }else {
        for(var row in grid) {
          for(Tile t in row) {
            t.reset();
          }
        }
      }

      for(int i = 0; i < tiles; i++) {
          int x = gen.nextInt(4);
          int y = gen.nextInt(4);
          int value = gen.nextDouble() < 0.1 ? 4 : 2;

          if(xy.contains((x,y)) ) {
            continue;
          }
          grid[x][y].value = value;
      }

      return GameData.newGame(state.score,grid);
  }

  // Start New Game
  void newGame() {
    state = _restart();
  }

  //Finish round, win or loose the game.
  void _endRound() {
    Iterable<Tile> tiles = state.gridTiles;
    bool full = tiles.where((t) => t.value != 0).toList().length == (GameInfo.scale*GameInfo.scale);
    bool won = tiles.where((t) => t.value == 2048).toList().isNotEmpty;
    bool lost = true;
    GameStatus status = state.status;
    List<List<Tile> > grid = state.grid;
    int bestScore = state.bestScore;

    if(full && !won) {
      for(int i = 0; i < grid.length; i++) {
        for(int j = 0; j < grid[i].length; j++) {
          int value = grid[i][j].value;
          List<int> values = [];

          //Check if there is a tile to the right
          if(j + 1 <  grid[i].length) {
            values.add(grid[i][j+1].value);
          }
          //Check if there is a tile to the left
          if(j - 1 >= 0) {
            values.add(grid[i][j-1].value);
          }
          //Check if there is a tile to the above
          if(i+1 < grid.length) {
            values.add(grid[i+1][j].value);
          }
          //Check if there is a tile to the below
          if(i-1 >= 0) {
            values.add(grid[i-1][j].value);
          }

          //Found match
          if(values.contains(value) ) {
            lost = false;
            break;
          }
        }
      }
    }

    if(won) {
      status = GameStatus.won;
    } else if(lost) {
      status = GameStatus.lost;
    }

    if(won || lost) {
      if(state.score > bestScore) {
        bestScore = state.score;
      }

    }

    state = state.copyWith(grid: grid, status: status,bestScore: bestScore);
  }

  //Mark the merged as false after the merge animation is complete.
  bool endRound() {
    //End round.
    _endRound();
    ref.read(roundManager.notifier).end();

    //If player moved too fast before the current animation/transition finished, start the move for the next direction
    var nextDirection = ref.read(nextDirectionManager);
    if (nextDirection != null) {
      //TODO Move
      ref.read(nextDirectionManager.notifier).clear();
      return true;
    }
    return false;
  }

}

final boardManager = StateNotifierProvider<BoardManager,GameData>((ref) {
  return BoardManager(ref);
});