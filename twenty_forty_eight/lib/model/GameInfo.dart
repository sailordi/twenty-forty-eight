import 'package:flutter/material.dart';
import 'dart:math';

class GameInfo {
  final double spaceBetweenTiles = 10;
  final int scale = 4;

  late final double width;
  late final double height;
  late final double tileSize;

  GameInfo(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    width = min(screenSize.width,screenSize.height * 11 / 16);
    height = width;
    tileSize = (width - spaceBetweenTiles * (scale + 1) ) / (scale);
  }
}