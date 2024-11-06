// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllSongModelAdapter extends TypeAdapter<AllSongModel> {
  @override
  final int typeId = 1;

  @override
  AllSongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllSongModel(
      id: fields[0] as int?,
      songTitle: fields[1] as String,
      artist: fields[2] as String,
      uri: fields[3] as String,
      songPath: fields[4] as String,
      imageUri: fields[5] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, AllSongModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.songTitle)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.uri)
      ..writeByte(4)
      ..write(obj.songPath)
      ..writeByte(5)
      ..write(obj.imageUri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllSongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
