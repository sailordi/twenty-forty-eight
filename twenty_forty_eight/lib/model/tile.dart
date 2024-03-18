import 'package:flutter/material.dart';
import 'gameInfo.dart';

class Tile {
  final int x;
  final int y;
  final double moveInterval = .5;

  int value;

  late Animation<double> animatedX;
  late Animation<double> animatedY;
  late Animation<double> size;

  late Animation<int> animatedValue;

  Tile(this.x,this.y,[this.value = 0]) {
    resetAnimations();
  }

  void resetAnimations() {
    animatedX = AlwaysStoppedAnimation(x.toDouble());
    animatedY = AlwaysStoppedAnimation(y.toDouble());
    size = const AlwaysStoppedAnimation(1.0);
    animatedValue = AlwaysStoppedAnimation(value);
  }

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

  static Color textColor(int value) {
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

  void moveTo(Animation<double> parent, int x, int y) {
    Animation<double> curved = CurvedAnimation(parent: parent, curve: Interval(0.0, moveInterval));
    animatedX = Tween(begin: this.x.toDouble(), end: x.toDouble()).animate(curved);
    animatedY = Tween(begin: this.y.toDouble(), end: y.toDouble()).animate(curved);
  }

  void bounce(Animation<double> parent) {
    size = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1.0),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(moveInterval, 1.0)));
  }

  void changeNumber(Animation<double> parent, int newValue) {
    animatedValue = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(value), weight: .01),
      TweenSequenceItem(tween: ConstantTween(newValue), weight: .99),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(moveInterval, 1.0)));
  }

  void appear(Animation<double> parent) {
    size = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: parent, curve: Interval(moveInterval, 1.0)));
  }

  Tile copy() {
    Tile t = Tile(x, y, value);

      return t;
  }

}