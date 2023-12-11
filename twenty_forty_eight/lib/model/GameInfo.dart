import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/bloc/game_bloc.dart';
import 'dart:math';
import 'dart:developer' as dev;
import 'Tile.dart';

enum Direction {
  up,
  down,
  left,
  right,
}

class GameInfo {
  final double spaceBetweenTiles = 10;
  static const int scale = 4;
  static const int gestureSensitive = 3;

  late final double width;
  late final double height;
  late final double tileSize;

  GameInfo(BuildContext context) {
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));

    //Decide the size of the tile based on the size of the board minus the space between each tile.
    final sizePerTile = (size / 4).floorToDouble();

    width = sizePerTile * 4+30;
    height = width;
    tileSize = sizePerTile - 12.0 - (12.0 / 4);
  }

  static bool validPos({required (int,int) pos}) {
    return 0 <= pos.$1 && pos.$1 < scale && 0 <= pos.$2 && pos.$2 < scale;
  }

  static Tile getTile((int,int) pos,List<List<Tile> > grid,Direction dir) {
    if(!validPos(pos: pos) ) {
      dev.log("Invalid position [getTile] (row: ${pos.$1} col: ${pos.$2})");
      assert(false);
    }

    int i = pos.$1,j = pos.$2;

    switch (dir) {
      case Direction.down:
          return grid[i][j];
      case Direction.up:
        return grid[scale - i - 1][scale - j - 1];
      case Direction.left:
          return grid[j][scale - i - 1];
      case Direction.right:
          return grid[scale - j - 1][i];
    }

  }

  static void setTile((int,int) pos,List<List<Tile> > grid,Direction dir,int val) {
    if(!validPos(pos: pos) ) {
      dev.log("Invalid position [setTile] (row: ${pos.$1} col: ${pos.$2})");
      assert(false);
    }

    int i = pos.$1,j = pos.$2;

    switch (dir) {
      case Direction.down:
        grid[i][j].value = val;
        break;
      case Direction.up:
        grid[scale - i - 1][scale - j - 1].value = val;
        break;
      case Direction.left:
        grid[j][scale - i - 1].value = val;
        break;
      case Direction.right:
        grid[scale - j - 1][i].value = val;
        break;
    }

  }

  static (int,GameStatus) moveTile((int,int) pos,(int,int) newPos,List<List<Tile> > grid,Direction dir,int score) {
    if(!validPos(pos: pos) ) {
      dev.log("Invalid position [moveTile] (row: ${pos.$1} col: ${pos.$2})");
      assert(false);
    }
    if(!validPos(pos: newPos) ) {
      dev.log("Invalid new position [moveTile] (row: ${newPos.$1} col: ${newPos.$2})");
      assert(false);
    }
    GameStatus status = GameStatus.none;

    if(pos == newPos) {
      return (score,status);
    }

    Tile t1 = getTile(pos,grid,dir);
    Tile t2 = getTile(newPos,grid,dir);

    if(t1.value == t2.value) {
      int v = t1.value*2;

      setTile(newPos,grid,dir,v);

      if(v == Tile.maxValue() ) {
        status = GameStatus.won;
      }

      score += v;
    } else if(t2.value == 0) {
      setTile(newPos,grid,dir,t1.value);
    }
    setTile(pos,grid,dir,0);

    return (score,status);
  }

  static bool lost(List<List<Tile> > grid) {
    for (int i = 0; i < scale; ++i) {
      for (int j = 0; j < scale; ++j) {
        Tile t = grid[i][j];

        if (t.value == 0) {
          return false;
        }

        if(i == 0 && j == 0) {
          continue;
        }

        if(i != 0 && t.value == grid[i-1][j].value) {
          return false;
        }
        if(j != 0 && t.value == grid[i][j-1].value) {
          return false;
        }

      }
    }
    return true;
  }

}