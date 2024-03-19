import 'package:flutter/material.dart';

class GameInfo {
  final double spaceBetweenTiles = 10;
  final int scale = 4;

  double contentPadding = 16;
  double borderSize = 4;
  late double gridSize;
  late double tileSize;

  static const Color lightBrown = Color.fromARGB(255,205,193,180);
  static const Color darkBrown = Color.fromARGB(255,187,173,160);
  static const Color tan = Color.fromARGB(255,238,228,218);
  static const Color gray = Color.fromARGB(255,119,110,101);
  static const double cornerRadius = 8.0;

  GameInfo(BuildContext context) {
    gridSize = MediaQuery.of(context).size.width - contentPadding * 2;
    tileSize =  (gridSize - borderSize * 2) / 4;
  }
}