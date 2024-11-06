import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecentPlaysWidget extends StatelessWidget {
  const RecentPlaysWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<RecentPlayModel>>(
      valueListenable: recentPlayNotifier,
      builder: (context, recentPlays, child) {
        return SizedBox(
          height: 160,
          child: recentPlays.isEmpty
              ? const Center(
                  child: Text(
                    "No Recent Plays",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentPlays.length,
                  itemBuilder: (context, index) {
                    final play = recentPlays[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayingNow(
                              song: play,
                              allSongs: allSongNotifier.value,
                              recentPlays: recentPlayNotifier.value,
                              isFromRecent: true,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: QueryArtworkWidget(
                                artworkFit: BoxFit.fill,
                                id: play.id,
                                type: ArtworkType.AUDIO,
                                artworkHeight: 100,
                                artworkWidth: 120,
                                nullArtworkWidget: Container(
                                  height: 100,
                                  width: 120,
                                  color: Colors.green,
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              play.songTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              play.artist,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}