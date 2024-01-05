import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'tile.g.dart'; // Hive generates this file

@HiveType(typeId: 0)
class Tile {
  @HiveField(0)
  final int value;
  @HiveField(1)
  final int x;
  @HiveField(2)
  final int y;

  Tile(this.value,this.x,this.y);

  static int maxValue() { return 2048; }

  Color color() {
    switch (value) {
      case 2:
        return Colors.orangeAccent;
      case 4:
        return Colors.orange;
      case 8:
        return Colors.deepOrange;
      case 16:
        return Colors.redAccent;
      case 32:
        return Colors.red;
      case 64:
        return Colors.yellowAccent;
      case 128:
        return Colors.yellow;
      case 256:
        return Colors.greenAccent;
      case 512:
        return Colors.lightGreenAccent;
      case 1024:
        return Colors.lightGreen;
      case 2048:
        return Colors.green;
      default:
        return Colors.grey;
    }



  }

}