// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tile _$TileFromJson(Map json) => Tile(
      json['x'] as int,
      json['y'] as int,
      nextX: json['nextX'] as int?,
      nextY: json['nextY'] as int?,
      merged: json['merged'] as bool? ?? false,
      value: json['value'] as int? ?? 0,
      id: json['id'] ?? "",
    );

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'id': instance.id,
      'x': instance.x,
      'y': instance.y,
      'nextX': instance.nextX,
      'nextY': instance.nextY,
      'value': instance.value,
      'merged': instance.merged,
    };
