import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as dev;
import 'tile.dart';

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

}