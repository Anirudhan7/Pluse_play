import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';

class AllSongsWidget extends StatelessWidget {
  const AllSongsWidget({
    super.key,
    required this.song,
  });

  final AllSongModel song;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: QueryArtworkWidget(
              id: song.id!,
              type: ArtworkType.AUDIO,
              nullArtworkWidget:
                  const Icon(Icons.music_note,color: Colors.white,),
              artworkFit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            song.songTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            song.artist,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
