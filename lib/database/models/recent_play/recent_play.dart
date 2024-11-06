import 'dart:typed_data';
import 'package:hive/hive.dart';
part 'recent_play.g.dart';
@HiveType(typeId: 5)
class RecentPlayModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String songTitle;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String? uri;

  @HiveField(4)
  Uint8List imageUri;

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final String songPath;

  RecentPlayModel({
    required this.id,
    required this.songTitle,
    required this.artist,
    required this.uri,
    required this.imageUri,
    required this.timestamp,
    required this.songPath,
  });

  Uint8List get imageBytes => imageUri;

  set imageBytes(Uint8List bytes) {
    imageUri = bytes;
  }
}
