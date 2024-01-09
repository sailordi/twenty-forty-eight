// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameAdapter extends TypeAdapter<Game> {
  @override
  final int typeId = 1;

  @override
  Game read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game()
      ..grid = (fields[0] as List)
          .map((dynamic e) => (e as List).cast<Tile>())
          .toList()
      ..score = fields[1] as int
      ..highScore = fields[2] as int
      ..gameState = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.grid)
      ..writeByte(1)
      ..write(obj.score)
      ..writeByte(2)
      ..write(obj.highScore)
      ..writeByte(3)
      ..write(obj.gameState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
