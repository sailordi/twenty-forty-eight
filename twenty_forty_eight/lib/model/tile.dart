import 'package:flutter/material.dart';
import 'gameInfo.dart';

class Tile {
  int x;
  int y;
  int? nextX;
  int? nextY;
  int value;
  bool merged = false;

  Tile(this.x,this.y,{this.nextX, this.nextY, this.merged = false,this.value = 0});

  static int maxValue() { return 2048; }

  Color tileColor() {
    switch (value) {
      case 0:
        return GameInfo.lightBrown;
      case 2:
        return GameInfo.tan;
      case 4:
        return GameInfo.tan;
      case 8:
        return const Color.fromARGB(255,242,177,121);
      case 16:
        return const Color.fromARGB(255,245,149,99);
      case 32:
        return const Color.fromARGB(255,246,124,95);
      case 64:
        return const Color.fromARGB(255,246,95,64);
      case 128:
        return const Color.fromARGB(255,235,208,117);
      case 256:
        return const Color.fromARGB(255,237,203,103);
      case 512:
        return const Color.fromARGB(255,236,201,85);
      case 1024:
        return const Color.fromARGB(255,229,194,90);
      case 2048:
        return const Color.fromARGB(255,232,192,70);
      default:
        return Colors.cyan;
    }

  }

  Color textColor() {
    switch (value) {
      case 0:
        return GameInfo.lightBrown;
      case 2:
        return GameInfo.gray;
      case 4:
        return GameInfo.gray;
      default:
        return Colors.white;
    }
  }

  Tile copy() {
    Tile t = Tile(x, y, nextX: nextX,nextY: nextY,merged: merged,value: value);

      return t;
  }

  Tile copyWith({int? value,int? x,int? y,int? nextX,int? nextY, bool? merged}) =>
      Tile(x ?? this.x,
          y ?? this.y,
          nextX: nextX ?? this.nextX,
          nextY: nextY ?? this.nextY,
          merged: merged ?? this.merged,
          value: value ?? this.value);

  dynamic widget(double width,double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tileColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'nextX': nextX,
    'nextY': nextY,
    'merged': merged,
    'value': value,
  };

  static Tile fromJson(Map<String, dynamic> json) => Tile(
    json['x'] as int,
    json['y'] as int,
    nextX: json['nextX'] as int?,
    nextY: json['nextY'] as int?,
    merged: json['merged'] as bool? ?? false,
    value: json['value'] as int,
  );

}