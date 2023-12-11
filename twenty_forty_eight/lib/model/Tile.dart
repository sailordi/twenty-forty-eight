import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/model/GameInfo.dart';
import 'package:uuid/uuid.dart';

class Tile {
  late final String id;
  int value;
  int index;
  int? nextIndex;

  Tile({String i = "",required this.index,this.value = 0,this.nextIndex}) {
    if(i.isNotEmpty) {
      id = i;
    } else {
      id = const Uuid().v4();
    }

  }

  //Calculate the current top position based on the index
  double getTop(double size) {
    var i = ((index + 1) / GameInfo.scale).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  //Calculate the current left position based on the index
  double getLeft(double size) {
    var i = (index - (((index + 1) / GameInfo.scale).ceil() * GameInfo.scale - GameInfo.scale));
    return (i * size) + (12.0 * (i + 1));
  }

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

  Tile copyWith({String? id, int? value, int? index, int? nextIndex}) {
    String i = (id == null) ? this.id : id!;
    int v = (value == null) ? this.value : value!;
    int ind = (index == null) ? this.index : index!;
    int? nextInd = (nextIndex == null) ? this.nextIndex : nextIndex;

    return Tile(i: i,value: v,index: ind,nextIndex: nextInd);
  }
}