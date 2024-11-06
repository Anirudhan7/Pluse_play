import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';

ValueNotifier<List<FavoriteModel>> favoriteNotifier = ValueNotifier([]);

Future<void> addSongToFavorites(FavoriteModel song) async {
  final openDB = await Hive.openBox<FavoriteModel>("favorites_box");
  if (!openDB.containsKey(song.id)) {
    await openDB.put(song.id, song);
    favoriteNotifier.value.add(song);
    favoriteNotifier.notifyListeners();
    print("${song.songTitle} added to favorites.");
  } else {
    print("${song.songTitle} is already in favorites.");
  }
}

Future<void> getAllSongsFromFavorites() async {
  final songDB = await Hive.openBox<FavoriteModel>("favorites_box");
  favoriteNotifier.value = songDB.values.toList(); 
  favoriteNotifier.notifyListeners();
}

Future<void> deleteFromFavorites(int id) async {
  final openDB = await Hive.openBox<FavoriteModel>("favorites_box");
  await openDB.delete(id);
  favoriteNotifier.value.removeWhere((song) => song.id == id); 
  favoriteNotifier.notifyListeners();
}
