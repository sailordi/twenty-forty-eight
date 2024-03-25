import 'package:flutter/material.dart';
import 'dart:math';

class GameInfo {
  static const  int scale = 4;
  static const double spaceBetweenTiles = 10;

  late final double width;
  late final double height;
  late final double tileSize;


  static const Color lightBrown = Color.fromARGB(255,205,193,180);
  static const Color darkBrown = Color.fromARGB(255,187,173,160);
  static const Color tan = Color.fromARGB(255,238,228,218);
  static const Color gray = Color.fromARGB(255,119,110,101);
  static const Color orange = Color.fromARGB(255,245,149,99);
  static const Color numColor = Color.fromARGB(255, 119, 110, 101);
  static const double cornerRadius = 8.0;

  GameInfo(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    width = min(screenSize.width,screenSize.height*7 / (scale*scale));
    height = width;
    tileSize = (width - spaceBetweenTiles * (scale + 1) ) / (scale);
  }
}