import 'package:hive_flutter/hive_flutter.dart';

import '../models/gameData.dart';

class GameDataAdapter extends TypeAdapter<GameData> {
  @override
  final typeId = 0;

  @override
  GameData read(BinaryReader reader) {
    //Create a Board models from the json when reading the data that's being stored.
    return GameData.fromJson(Map<String, dynamic>.from(reader.read()));
  }

  @override
  void write(BinaryWriter writer, GameData obj) {
    //Store the board models as json when writing the data to the database.
    writer.write(obj.toJson());
  }
}