import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'gameInfo.dart';

part 'tile.g.dart';

@JsonSerializable(anyMap: true)
class Tile {
  String id = "";
  int x;
  int y;
  int? nextX;
  int? nextY;
  int value;
  bool merged = false;

  Tile(this.x,this.y,{this.nextX, this.nextY, this.merged = false,this.value = 0,id = ""}) {
    if(id == "") {
      this.id = const Uuid().v4();
    }else {
      this.id = id;
    }

  }

  static int maxValue() { return 2048; }

  double top(double size) {
    return (y * size) + (GameInfo.spaceBetweenTiles * (y + 1) );
  }

  double left(double size) {
    return (x * size) + (12.0 * (x + 1) );
  }

  double? nextTop(double size) {
    if (nextY == null) return null;

    return (nextY! * size) + (GameInfo.spaceBetweenTiles * (nextY! + 1) );
  }

  double? nextLeft(double size) {
    if (nextX == null) return null;

    return (nextX! * size) + (GameInfo.spaceBetweenTiles * (nextX! + 1) );
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

  Tile copy() {
    Tile t = Tile(x, y, nextX: nextX,nextY: nextY,merged: merged,value: value);

      return t;
  }

  Tile copyWith({int? value,int? x,int? y,int? nextX,int? nextY, bool? merged,String? id}) =>
      Tile(x ?? this.x,
          y ?? this.y,
          nextX: nextX ?? this.nextX,
          nextY: nextY ?? this.nextY,
          merged: merged ?? this.merged,
          value: value ?? this.value,
          id: id ?? this.id
      );

  void reset({int? value}) {
    merged = false;
    this.value = value ?? 0;
    nextX = null;
    nextY = null;
  }

  //Create a Tile from json data
  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

  //Generate json data from the Tile
  Map<String, dynamic> toJson() => _$TileToJson(this);

}