import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';
import 'package:pluseplay/screens/widgets/all_songs_widget.dart';

class ArtistSongsPage extends StatelessWidget {
  final String artistName;

  const ArtistSongsPage({Key? key, required this.artistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artistName),
        backgroundColor: const Color.fromARGB(255, 13, 3, 56),
      ),
      backgroundColor: const Color.fromARGB(255, 12, 5, 144),
      body: ValueListenableBuilder<List<AllSongModel>>(
        valueListenable: allSongNotifier,
        builder: (context, allSongs, child) {
          // Filter songs by the selected artist
          final artistSongs = allSongs.where((song) => song.artist == artistName).toList();

          return artistSongs.isEmpty
              ? const Center(
                  child: Text(
                    "No Songs Found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: artistSongs.length,
                  // Set background color of the ListView
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    final song = artistSongs[index];
                    return Container(
                      color: const Color.fromARGB(255, 12, 5, 144), // Set color for each item container
                      child: GestureDetector(
                        onTap: () {
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
                        child: AllSongsWidget(song: song),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
