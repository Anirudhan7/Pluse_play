import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';

ValueNotifier<List<AllSongModel>> allSongNotifier = ValueNotifier([]);

Future<void> addToAllsong(List<SongModel> songs1) async {
  Uint8List? imagebyte;
  final openDB = await Hive.openBox<AllSongModel>("All_song");
  await openDB.clear();
  allSongNotifier.value.clear();

  for (var song in songs1) {
    var allSong = AllSongModel(
      id: song.id,
      songTitle: song.title,
      artist: song.artist ?? "unknown",
      uri: song.uri ?? '',
      songPath: song.data,
      imageUri: imagebyte ?? Uint8List(0),
    );
    await openDB.put(song.id, allSong);
    print(song.id);
  }
  allSongNotifier.value = openDB.values.toList();
}

Future<void> getAllSongs() async {
  final songDB = await Hive.openBox<AllSongModel>("All_song");
  allSongNotifier.value.clear();
  allSongNotifier.value.addAll(songDB.values);
}
