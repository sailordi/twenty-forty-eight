// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tile _$TileFromJson(Map json) => Tile(
      json['index'] as int,
      nextIndex: json['nextIndex'] as int?,
      merged: json['merged'] as bool? ?? false,
      value: json['value'] as int? ?? 0,
      id: json['id'] ?? "",
    );

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'nextIndex': instance.nextIndex,
      'value': instance.value,
      'merged': instance.merged,
    };
