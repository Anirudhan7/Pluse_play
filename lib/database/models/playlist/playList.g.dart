// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 2;

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlist(
      name: fields[1] as String,
      songs: (fields[2] as List?)?.cast<PlaylistSongModel>(),
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.songs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlaylistSongModelAdapter extends TypeAdapter<PlaylistSongModel> {
  @override
  final int typeId = 4;

  @override
  PlaylistSongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaylistSongModel(
      id: fields[0] as int,
      songTitle: fields[1] as String,
      artist: fields[2] as String,
      uri: fields[3] as String,
      imageUri: fields[4] as Uint8List?,
      songPath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistSongModel obj) {
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
      ..write(obj.imageUri)
      ..writeByte(5)
      ..write(obj.songPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistSongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
