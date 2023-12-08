import 'package:flutter/material.dart';

class Tile {
  int value;

  Tile({this.value = 0});

  dynamic widget(double width,double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color(value),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value == 0 ? '' : value.toString(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static int maxValue() { return 2048; }

  Color color(int value) {
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