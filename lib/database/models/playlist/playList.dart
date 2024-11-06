import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'playList.g.dart';

@HiveType(typeId: 2) 
class Playlist {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<PlaylistSongModel> songs;

  Playlist({
    required this.name,
    List<PlaylistSongModel>? songs,
    this.id,
  }) : songs = songs ?? [];
}

@HiveType(typeId: 4) 
class PlaylistSongModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  final String songTitle;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String uri;

  @HiveField(4)
  Uint8List? imageUri;

  @HiveField(5)
  final String songPath;

  PlaylistSongModel({
    required this.id,
    required this.songTitle,
    required this.artist,
    required this.uri,
    required this.imageUri,
    required this.songPath,
  });

  Uint8List? get imageBytes => imageUri;

  set imageBytes(Uint8List? bytes) {
    imageUri = bytes;
  }
}
