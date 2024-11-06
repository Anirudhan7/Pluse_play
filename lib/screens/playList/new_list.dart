import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/function/playlists/plaListfunc.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistName;

  const PlaylistDetailScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
        backgroundColor: const Color.fromARGB(255, 13, 3, 56),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Color.fromARGB(255, 12, 5, 144)],
          ),
        ),
        child: ValueListenableBuilder<List<Playlist>>(
          valueListenable: playlistsNotifier,
          builder: (context, playlists, child) {
            // Fetch the playlist by name
            final playlist = playlists.firstWhere(
              (p) => p.name == playlistName,
              orElse: () => Playlist(name: playlistName, songs: []), // Return an empty playlist if not found
            );

            if (playlist.songs.isNotEmpty) {
              return ListView.builder(
                itemCount: playlist.songs.length,
                itemBuilder: (context, index) {
                  final song = playlist.songs[index];
                  return ListTile(
                    leading: QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.grey,
                      ),
                    ),
                    title: Text(
                      song.songTitle,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Navigate to the PlayingNow screen with the song
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayingNow(
                            song: song,
                            allSongs: allSongNotifier.value,
                            recentPlays: recentPlayNotifier.value,
                            isFromRecent: false,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "No songs in this playlist.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}