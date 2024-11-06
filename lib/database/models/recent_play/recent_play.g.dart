// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_play.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentPlayModelAdapter extends TypeAdapter<RecentPlayModel> {
  @override
  final int typeId = 5;

  @override
  RecentPlayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentPlayModel(
      id: fields[0] as int,
      songTitle: fields[1] as String,
      artist: fields[2] as String,
      uri: fields[3] as String?,
      imageUri: fields[4] as Uint8List,
      timestamp: fields[5] as DateTime,
      songPath: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentPlayModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.songTitle)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.uri)
      ..writeByte(4)
      ..write(obj.imageUri)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.songPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentPlayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
