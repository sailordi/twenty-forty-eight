// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map json) => Board(
      json['score'] as int,
      json['best'] as int,
      (json['tiles'] as List<dynamic>)
          .map((e) => Tile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      status: stringStatus[json['status'] as String]!
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'score': instance.score,
      'best': instance.bestScore,
      'tiles': instance.tiles.map((e) => e.toJson()).toList(),
      'status': statusString[instance.status]
    };