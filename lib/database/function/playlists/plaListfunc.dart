import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';

ValueNotifier<List<Playlist>> playlistsNotifier = ValueNotifier([]);

Future<void> createPlaylist({required String playlistName}) async {
  final newPlaylist = Playlist(name: playlistName);
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');

  final key = await playlistBox.add(newPlaylist);
  newPlaylist.id = key;
  await playlistBox.put(key, newPlaylist);
  
  await getPlaylists(); 
}

Future<void> getPlaylists() async {
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');
  playlistsNotifier.value = playlistBox.values.toList();
  playlistsNotifier.notifyListeners();
}

Future<void> addSongToPlaylist(String playlistName, PlaylistSongModel song) async {
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');
  final playlist = playlistBox.values.firstWhere(
    (playlist) => playlist.name == playlistName,
  );

  // Check if the song already exists in the playlist
  if (!playlist.songs.any((existingSong) => existingSong.id == song.id)) {
    List<PlaylistSongModel> updatedSongs = List.from(playlist.songs);
    updatedSongs.add(song);
    playlist.songs = updatedSongs;
    await playlistBox.put(playlist.id!, playlist);
    await getPlaylists(); 
  } else {
    print('Song "${song.songTitle}" is already in the playlist "${playlistName}".');
  }
}

Future<void> removeSongFromPlaylist(String playlistName, PlaylistSongModel song) async {
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');
  final playlist = playlistBox.values.firstWhere(
    (playlist) => playlist.name == playlistName,
  );

  playlist.songs.removeWhere((existingSong) => existingSong.id == song.id);
  await playlistBox.put(playlist.id!, playlist);
  
  await getPlaylists(); 
}

Future<void> deletePlaylist(int key) async {
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');
  await playlistBox.delete(key);
  
  await getPlaylists(); 
}

Future<void> updatePlaylistName(int id, String newPlaylistName) async {
  final playlistBox = await Hive.openBox<Playlist>('playlistbox');
  Playlist? playlist = playlistBox.get(id);
  if (playlist != null) {
    playlist.name = newPlaylistName;
    await playlistBox.put(id, playlist);
  }
  await getPlaylists(); 
}