import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'gameInfo.dart';

part 'tile.g.dart';

@JsonSerializable(anyMap: true)
class Tile {
  String id = "";
  int index;
  int? nextIndex;
  int value;
  bool merged = false;

  Tile(this.index,{this.nextIndex, this.merged = false,this.value = 0,id = ""}) {
    if(id == "") {
      this.id = const Uuid().v4();
    }else {
      this.id = id;
    }

  }

  static int maxValue() { return 2048; }

  double top(double size) {
    var i = ( (index + 1) / GameInfo.scale).ceil();

    return ( (i - 1) * size) + (GameInfo.spaceBetweenTiles * i);
  }

  double left(double size) {
    var i = (index - ( ( (index + 1) / GameInfo.scale).ceil() * GameInfo.scale - GameInfo.scale) );

    return (i * size) + (GameInfo.spaceBetweenTiles * (i + 1));
  }

  double? nextTop(double size) {
    if (nextIndex == null) { return null; }

    var i = ( (nextIndex! + 1) / GameInfo.scale).ceil();

    return ( (i - 1) * size) + (GameInfo.spaceBetweenTiles * i);
  }

  double? nextLeft(double size) {
    if (nextIndex == null) return null;

    var i = (nextIndex! - ( ( (nextIndex! + 1) / GameInfo.scale).ceil() * GameInfo.scale - GameInfo.scale) );

    return (i * size) + (GameInfo.spaceBetweenTiles * (i + 1));
  }

  Color tileColor() {
    switch (value) {
      case 2:
        return const Color(0xffeee4da);
      case 4:
        return const Color(0xffeee1c9);
      case 8:
        return const Color(0xfff3b27a);
      case 16:
        return const Color(0xfff69664);
      case 32:
        return const Color(0xfff77c5f);
      case 64:
        return const Color(0xfff75f3b);
      case 128:
        return const Color(0xffedd073);
      case 256:
        return const Color(0xffedcc62);
      case 512:
        return const Color(0xffedc950);
      case 1024:
        return const Color(0xffedc53f);
      case 2048:
        return const Color(0xffedc22e);
      default:
        return Colors.cyan;
    }

  }

  Color textColor() {
    return (value < 8) ? GameInfo.textColor : GameInfo.textColorWhite;
  }

  Tile copyWith({int? value,int? index,int? nextIndex, bool? merged,String? id}) =>
      Tile(index ?? this.index,
          nextIndex: nextIndex ?? this.nextIndex,
          merged: merged ?? this.merged,
          value: value ?? this.value,
          id: id ?? this.id
      );

  //Create a Tile from json data
  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  //Generate json data from the Tile
  Map<String, dynamic> toJson() => _$TileToJson(this);

}