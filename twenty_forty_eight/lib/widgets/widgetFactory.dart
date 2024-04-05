import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';
import 'package:twenty_forty_eight/models/tile.dart';
import 'package:twenty_forty_eight/widgets/tileWidget.dart';

class WidgetFactory {
  static dynamic logo() {
    return const Text(
        "2048", style: TextStyle(fontSize: 52.0, fontWeight: FontWeight.bold));
  }

  static dynamic instructions() {
    const double fontSize = 15;

    return Row(
        children: [
          const Text("Join the numbers and get to the ",
              style: TextStyle(fontSize: fontSize)),
          Text("${Tile.maxValue()} tile", style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: fontSize)),
        ]
    );
  }

}