// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gameData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameData _$GameDataFromJson(Map json) => GameData(
      json['score'] as int,
      json['bestScore'] as int,
      (json['grid'] as List<dynamic>)
          .map((e) => Tile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      status: $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.init,
    );

Map<String, dynamic> _$GameDataToJson(GameData instance) => <String, dynamic>{
      'grid': instance.grid.map((e) => e.toJson()).toList(),
      'score': instance.score,
      'bestScore': instance.bestScore,
      'status': _$GameStatusEnumMap[instance.status]!,
    };

const _$GameStatusEnumMap = {
  GameStatus.init: 'init',
  GameStatus.playing: 'playing',
  GameStatus.won: 'won',
  GameStatus.lost: 'lost',
};
