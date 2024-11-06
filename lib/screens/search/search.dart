import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for songs...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<List<AllSongModel>>(
                valueListenable: allSongNotifier,
                builder: (context, allSongs, child) {
                  final filteredSongs = allSongs
                      .where((song) =>
                          song.songTitle.toLowerCase().contains(query.toLowerCase()))
                      .toList();

                  if (filteredSongs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Songs Found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return ListTile(
                        leading: QueryArtworkWidget(
                          id: song.id!,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(Icons.music_note),
                        ),
                        title: Text(
                          song.songTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}