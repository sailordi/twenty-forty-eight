import 'dart:ffi';
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
      Grid grid = state.grid;

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
        _randomTile(grid);
      }

      return GameData.newGame(state.score,grid);
  }

  // Start New Game
  void newGame() {
    state = _restart();
  }

  Tile? _nextTileMerge(int i,int j,Tile t,Grid g) {
    Tile? tL,tR,tU,tD;

    if(j-1 >= 0 && j-1 < g[i].length) {
      tL = g[i][j-1];
    }
    if(j+1 >= 0 && j+1 < g.length) {
      tR = g[i][j+1];
    }
    if(i-1 >= 0 && i-1 < g.length) {
      tU = g[i-1][j];
    }
    if(i+1 >= 0 && i+1 < g.length) {
      tD = g[i+1][j];
    }

    if(tL != null && t.nextX == tL.nextX && t.nextY == tL.nextY) {
      return tL;
    }
    if(tR != null && t.nextX == tR.nextX && t.nextY == tR.nextY) {
      return tR;
    }
    if(tU != null && t.nextX == tU.nextX && t.nextY == tU.nextY) {
      return tU;
    }
    if(tD != null && t.nextX == tD.nextX && t.nextY == tD.nextY) {
      return tD;
    }

    return null;
  }

  void merge() {
    var grid = state.grid;
    int size = grid.length;
    bool merged = false;
    int score = state.score;

    for(int i = 0; i < size; i++) {
      for(int j = 0; j < grid[i].length; j++) {
        Tile t = grid[i][j];

        if(t.value == 0 || (t.nextX == null && t.nextY == null) ) {
          continue;
        }
        Tile? nT = _nextTileMerge(i,j,t,grid);

        if(nT == null || nT.nextX != t.nextX && nT.nextY != t.nextY) {
          continue;
        }
        var value = nT.value;
        merged = true;
        score += value;
        t.x = t.nextX!;
        t.y = t.nextY!;
        t.value += value;
        t.merged = true;
      }

    }

    if(merged) {
      _randomTile(grid);
    }

    state = state.copyWith(score: score,grid: grid);
  }

  void _randomTile(Grid g) {
    var emptyTiles = GameData.gridTiles(g).where((t) => t.value == 0).toList();

    if(emptyTiles.isEmpty) {
      return;
    }
    Random gen = Random();
    int value = gen.nextDouble() < 0.1 ? 4 : 2;

    emptyTiles.shuffle();

    emptyTiles.first.value = value;
  }

  Tile? _nextTileMove(int i, int j,Grid g,SwipeDirection direction) {
    if(direction == SwipeDirection.left) {
      j -= 1;
    }
    else if(direction == SwipeDirection.right) {
      j += 1;
    }
    else if(direction == SwipeDirection.up) {
      i -= 1;
    }
    else if(direction == SwipeDirection.down) {
      i += 1;
    }

    if(i < 0 || i >= g.length) {
      return null;
    }

    if(direction == SwipeDirection.up && direction == SwipeDirection.up) {
      return g[i][j];
    }

    if(j < 0 || j >= g[i].length) {
      return null;
    }

    return g[i][j];

  }
  Tile _tileMove(int i, int j,Grid g,SwipeDirection direction) {
    int nextI = i,nextJ = j;

    if(direction == SwipeDirection.left) {
      nextJ -= 1;
    }
    else if(direction == SwipeDirection.right) {
      nextJ += 1;
    }
    else if(direction == SwipeDirection.up) {
      nextI -= 1;
    }
    else if(direction == SwipeDirection.down) {
      nextI += 1;
    }

    Tile t = g[i][j];

    if(nextI < 0 && nextI >= g.length) {
      return t;
    }

    if(direction != SwipeDirection.up && direction != SwipeDirection.up) {
      if(nextI >= 0 && nextI < g.length) {
        t.nextX = nextI;
      }

    }
    else {
      if(j >= 0 && j < g[i].length) {
        t.nextY = nextJ;
      }

    }

    return t;
  }

  bool move(SwipeDirection direction) {
    if(state.status != GameStatus.playing) {
      return false;
    }

    var grid = state.grid;
    int size = grid.length;

      for(int i = 0; i < size; i++) {

        for(int j = 0; j < grid[i].length; j++) {
          Tile t = _tileMove(i,j,grid,direction);

          if(t.value == 0) {
            continue;
          }
          Tile? nT = _nextTileMove(i,j,grid,direction);

          if(nT == null || (nT.value != 0 && nT.value != t.value) ) {
            continue;
          }
          if(nT.nextX != null && nT.nextY != null) {
            nT.nextX = t.nextX;
            nT.nextY = t.nextY;
          }

        }

      }

      state = state.copyWith(grid: grid);

      return true;
  }

  //Finish round, win or loose the game.
  void _endRound() {
    Iterable<Tile> tiles = GameData.gridTiles(state.grid);
    bool full = tiles.where((t) => t.value != 0).toList().length == (GameInfo.scale*GameInfo.scale);
    bool won = tiles.where((t) => t.value == 2048).toList().isNotEmpty;
    bool lost = false;
    GameStatus status = state.status;
    List<List<Tile> > grid = state.grid;
    int bestScore = state.bestScore;

    if(full && !won) {
      lost = true;

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

    if(status != GameStatus.playing && state.score > bestScore) {
        bestScore = state.score;
    }

    for(var row in grid) {
      for(Tile t in row) {
        t.reset(value: t.value);
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
      move(nextDirection);
      ref.read(nextDirectionManager.notifier).clear();
      return true;
    }

    return false;
  }

}

final boardManager = StateNotifierProvider<BoardManager,GameData>((ref) {
  return BoardManager(ref);
});