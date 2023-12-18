import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';

part 'tile.g.dart';

class Tile {
  late final String id;
  final int value;
  final int index;
  final int? nextIndex;
  final bool merged;

  Tile({String i = "",required this.index,this.value = 0,this.nextIndex, this.merged = false} ) {
    if(i.isNotEmpty) {
      id = i;
    } else {
      id = const Uuid().v4();
    }

  }

  //Calculate the current top position based on index
  double top(double size) {
    var i = ((index + 1) / GameInfo.scale).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  //Calculate the current left position based on index
  double left(double size) {
    var i = (index - (((index + 1) / GameInfo.scale).ceil() * GameInfo.scale - GameInfo.scale));
    return (i * size) + (12.0 * (i + 1));
  }

  //Calculate the next top position based on next index
  double? nextTop(double size) {
    if (nextIndex == null) return null;

    var i = ((nextIndex! + 1) / GameInfo.scale).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  //Calculate the next left position based on next index
  double? nextLeft(double size) {
    if (nextIndex == null) return null;

    var i = (nextIndex! - (((nextIndex! + 1) / GameInfo.scale).ceil() * GameInfo.scale - GameInfo.scale));
    return (i * size) + (12.0 * (i + 1));
  }

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

  Tile copyWith({String? id, int? value, int? index, int? nextIndex}) {
    String i = (id == null) ? this.id : id;
    int v = (value == null) ? this.value : value;
    int ind = (index == null) ? this.index : index;
    int? nextInd = (nextIndex == null) ? this.nextIndex : nextIndex;

    return Tile(i: i,value: v,index: ind,nextIndex: nextInd);
  }

  //Create a Tile from json data
  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  //Generate json data from the Tile
  Map<String, dynamic> toJson() => _$TileToJson(this);

}