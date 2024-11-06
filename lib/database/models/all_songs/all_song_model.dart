import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'all_song_model.g.dart';

@HiveType(typeId: 1)
class AllSongModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String songTitle;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String uri;

  @HiveField(4)
  final String songPath;

  @HiveField(5)
  Uint8List? imageUri;

  AllSongModel({
    this.id,
    required this.songTitle,
    required this.artist,
    required this.uri,
    required this.songPath,
    required this.imageUri,
  });

  Uint8List? get imageBytes => imageUri;

  set imageBytes(Uint8List? bytes) {
    imageUri = bytes;
  }
}
