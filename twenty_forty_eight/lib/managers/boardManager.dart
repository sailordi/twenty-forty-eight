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
  final verticalOrder = [12, 8, 4, 0, 13, 9, 5, 1, 14, 10, 6, 2, 15, 11, 7, 3];

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
  GameData _restart({bool resetBest = false}) {
      Random gen = Random();
      int tiles = 0;
      Grid grid = [];
      Indexes indexes = [];

      while(tiles < 3) {
        tiles = gen.nextInt(2) + 3;
      }

      for(int i = 0; i < tiles; i++) {
        Tile? t = _randomTile(grid,indexes);

        if(t != null) {
          indexes.add(t.index);

          grid.add(t);
        }

      }

      if(!resetBest) {
        return GameData.newGame(state.score,grid);
      }
      return GameData.newGame(0,grid);
  }

  // Start New Game
  void newGame() {
    state = _restart();
  }

  void merge() {
    Grid grid = [];
    bool moved = false;
    int score = state.score;
    Indexes indexes = [];

    for (int i = 0, l = state.grid.length; i < l; i++) {
      Tile t = state.grid[i];

      var value = t.value, merged = false;

      if (i + 1 < l) {
        //sum the number of the two tiles with same index and mark the tile as merged and skip the next iteration.
        Tile next = state.grid[i + 1];

        if (t.nextIndex == next.nextIndex ||
            t.index == next.nextIndex && t.nextIndex == null) {
          value = t.value + next.value;
          merged = true;
          score += t.value;
          i += 1;
        }

      }

      if (merged || t.nextIndex != null && t.index != t.nextIndex) {
        moved = true;
      }

      grid.add(t.copyWith(
          index: t.nextIndex ?? t.index,
          nextIndex: null,
          value: value,
          merged: merged));

      indexes.add(grid.last.index);
    }

    if(moved) {
      Tile? newT = _randomTile(grid,indexes);
      //TODO test won
      //newT = _winingTile(grid,indexes);

      if(newT != null) {
        grid.add(newT);
      }


    }

    state = state.copyWith(score: score,grid: grid);
  }

  Tile? _randomTile(Grid g,Indexes indexes) {
    var emptyTiles = g.length == GameInfo.maxTiles();

    if(emptyTiles) {
      return null;
    }

    Random gen = Random();
    int i;
    int value = gen.nextDouble() < 0.1 ? 4 : 2;

    do {
      i = gen.nextInt(GameInfo.maxTiles() );
    } while (indexes.contains(i) );

    return Tile(i,value: value);
  }

  Tile? _winingTile(Grid g,Indexes indexes) {
    var emptyTiles = g.length == GameInfo.maxTiles();

    if(emptyTiles) {
      return null;
    }

    Random gen = Random();
    int i;
    int value = Tile.maxValue();

    do {
      i = gen.nextInt(GameInfo.maxTiles() );
    } while (indexes.contains(i) );

    return Tile(i,value: value);
  }

  // Check whether the indexes are in the same row or column in the board.
  bool _validIndexPair(index, nextIndex) {
    return index < 4 && nextIndex < 4 ||
        index >= 4 && index < 8 && nextIndex >= 4 && nextIndex < 8 ||
        index >= 8 && index < 12 && nextIndex >= 8 && nextIndex < 12 ||
        index >= 12 && nextIndex >= 12;
  }

  Tile _calculate(Tile tile,List<Tile> tiles,direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Get the first index from the left in the row
    int index = vert ? verticalOrder[tile.index] : tile.index;
    int nextIndex = ((index + 1) / 4).ceil() * 4 - (asc ? 4 : 1);

    // If the list of the new tiles to be rendered is not empty get the last tile
    if (tiles.isNotEmpty) {
      var last = tiles.last;
      // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
      var lastIndex = last.nextIndex ?? last.index;
      lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;
      if (_validIndexPair(index, lastIndex)) {
        // If the order is ascending set the tile after the last processed tile
        // If the order is descending set the tile before the last processed tile
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }

    // Return immutable copy of the current tile with the new next index
    return tile.copyWith(
        nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);

  }

  bool move(SwipeDirection direction) {
    if(state.status != GameStatus.playing) {
      return false;
    }

    bool asc = direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert = direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Sort the list of tiles by index.
    // If user swipes vertically use the verticalOrder list to retrieve the up/down index
    state.grid.sort(((a, b) =>
    (asc ? 1 : -1) *
        (vert
            ? verticalOrder[a.index].compareTo(verticalOrder[b.index])
            : a.index.compareTo(b.index))));

    Grid grid = [];

    for (int i = 0, l = state.grid.length; i < l; i++) {
      Tile tile = state.grid[i];

      // Calculate nextIndex for current tile.
      tile = _calculate(tile,grid,direction);
      grid.add(tile);

      if (i + 1 < l) {
        Tile next = state.grid[i + 1];

        // Assign current tile nextIndex or index to the next tile if its allowed to be moved.
        if (tile.value == next.value) {
          // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
          var index = vert ? verticalOrder[tile.index] : tile.index,
              nextIndex = vert ? verticalOrder[next.index] : next.index;

          if (_validIndexPair(index, nextIndex)) {
            grid.add(next.copyWith(nextIndex: tile.nextIndex));
            // Skip next iteration if next tile was already assigned nextIndex.
            i += 1;
            continue;
          }
        }
      }
    }
    state = state.copyWith(grid: grid);

    return true;
  }

  //Finish round, win or loose the game.
  void _endRound() {
    var oldGrid = state.grid;
    Grid grid = [];
    bool full = oldGrid.length >= GameInfo.maxTiles();
    bool won = oldGrid.where((t) => t.value == 2048).toList().isNotEmpty;
    bool lost = false;
    GameStatus status = state.status;
    int bestScore = state.bestScore;

    if(full && !won) {
      lost = true;

      oldGrid.sort(((a, b) => a.index.compareTo(b.index) ) );

      for (int i = 0, l = oldGrid.length; i < l; i++) {
        Tile t = oldGrid[i];

        var x = (i - (((i + 1) / GameInfo.scale).ceil() * GameInfo.scale - GameInfo.scale) );

        //Check if left tile can be merged
        if (x > 0 && i - 1 >= 0) {
          var left =  oldGrid[i - 1];

          if (t.value == left.value) {
            lost = false;
          }

        }
        //Check if right tile can be merged
        if (x < 3 && i + 1 < l) {
          var right = oldGrid[i + 1];

          if (t.value == right.value) {
            lost = false;
          }

        }
        //Check if tile above can be merged
        if (i - 4 >= 0) {
          var top = oldGrid[i - 4];

          if (t.value == top.value) {
            lost = false;
          }

        }
        //Check if tile below can be merged
        if (i + 4 < l) {
          var bottom = oldGrid[i + 4];

          if (t.value == bottom.value) {
            lost = false;
          }

        }
        grid.add(t.copyWith(merged: false) );
      }

    }
    else {
      for(Tile t in oldGrid) {
        grid.add(t.copyWith(merged: false) );
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

  void resetBestScore() {
    state = _restart(resetBest: true);
  }

}

final boardManager = StateNotifierProvider<BoardManager,GameData>((ref) {
  return BoardManager(ref);
});