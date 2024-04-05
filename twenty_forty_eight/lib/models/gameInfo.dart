import 'package:flutter/material.dart';
import 'dart:math';

class GameInfo {
  static const  int scale = 4;
  static const double spaceBetweenTiles = 12.0;

  late double width;
  late double height;
  late double tileSize;

  static const Color backgroundColor = Color(0xfffaf8ef);
  static const Color textColor = Color(0xff776e65);
  static const Color textColorWhite = Color(0xfff9f6f2);
  static const Color boardColor = Color(0xffbbada0);
  static const Color emptyTileColor = Color(0xffcdc1b4);
  static const Color buttonColor = Color(0xff8f7a66);
  static const Color scoreColor = Color(0xffbbada0);
  static const Color overlayColor = Color.fromRGBO(238, 228, 218, 0.73);

  static const double cornerRadius = 8.0;

  GameInfo(BuildContext context) {
    final size = max(290.0,
        min( (MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));
    final sizePerTile = (size/scale).floorToDouble();

    tileSize = sizePerTile - spaceBetweenTiles - (spaceBetweenTiles / scale);

    width = tileSize*scale;
    height = width;
    tileSize = (width - spaceBetweenTiles * (scale + 1) ) / (scale);
  }

  static int maxTiles() {
    return scale*scale;
  }

}