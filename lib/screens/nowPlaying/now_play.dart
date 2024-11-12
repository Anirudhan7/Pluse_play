import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/favourite/favourite.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';
import 'package:pluseplay/screens/playList/playlist.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';

class PlayingNow extends StatefulWidget {
  final dynamic song;
  final List<dynamic> allSongs; 
  final List<dynamic> recentPlays; 
  final bool isFromRecent; 

  const PlayingNow({
    Key? key,
    required this.song,
    required this.allSongs,
    required this.recentPlays,
    required this.isFromRecent,
  }) : super(key: key);

  @override
  _PlayingNowState createState() => _PlayingNowState();
}

class _PlayingNowState extends State<PlayingNow> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ValueNotifier<bool> isPlayingNotifier;
  late ValueNotifier<Duration> durationNotifier;
  late ValueNotifier<Duration> positionNotifier;
  late ValueNotifier<bool> isFavoriteNotifier;
  late List<dynamic> currentPlaylist; // Current playlist
  late int currentIndex; // Current song index

  @override
  void initState() {
    super.initState();
    isPlayingNotifier = ValueNotifier(false);
    durationNotifier = ValueNotifier(Duration.zero);
    positionNotifier = ValueNotifier(Duration.zero);
    isFavoriteNotifier = ValueNotifier(false);

    currentPlaylist = widget.isFromRecent ? widget.recentPlays : widget.allSongs;
    currentIndex = currentPlaylist.indexWhere((song) => song.id == widget.song.id);

    _initializePlayer();
    _updateFavoriteState();
    favoriteNotifier.addListener(_updateFavoriteState);

    _audioPlayer.positionStream.listen((newPosition) {
      if (mounted) positionNotifier.value = newPosition;
    });
    _audioPlayer.durationStream.listen((newDuration) {
      if (mounted) durationNotifier.value = newDuration ?? Duration.zero;
    });
    _audioPlayer.playingStream.listen((isPlaying) {
      if (mounted) isPlayingNotifier.value = isPlaying;
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNext(); // Automatically play the next song when the current one is finished
      }
    });
  }

  void _updateFavoriteState() {
    if (currentIndex < 0 || currentIndex >= currentPlaylist.length) {
      return;
    }
    final isFavorite = favoriteNotifier.value.any((fav) => fav.id == currentPlaylist[currentIndex].id);
    isFavoriteNotifier.value = isFavorite;
  }

  Future<void> _initializePlayer() async {
    try {
      if (currentPlaylist.isNotEmpty && currentIndex >= 0) {
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(currentPlaylist[currentIndex].uri)));
        await _audioPlayer.play();
        await addRecentPlay(RecentPlayModel(
          id: widget.song.id!,
          songTitle: widget.song.songTitle,
          artist: widget.song.artist,
          uri: widget.song.uri,
          imageUri: widget.song.imageBytes!,
          timestamp: DateTime.now(),
          songPath: widget.song.songPath,
        ));
        _updateFavoriteState();
      } else {
        throw Exception("Invalid song URI!");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing song: $e')),
        );
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (currentIndex < 0 || currentIndex >= currentPlaylist.length) {
      return;
    }

    final songId = currentPlaylist[currentIndex].id!;
    if (favoriteNotifier.value.any((fav) => fav.id == songId)) {
      await deleteFromFavorites(songId);
    } else {
      final newFavorite = FavoriteModel(
        id: songId,
        songTitle: currentPlaylist[currentIndex].songTitle,
        artist: currentPlaylist[currentIndex].artist,
        uri: currentPlaylist[currentIndex].uri,
        imageUri: currentPlaylist[currentIndex].imageBytes!,
        songPath: currentPlaylist[currentIndex].songPath,
      );
      await addSongToFavorites(newFavorite);
    }
    _updateFavoriteState();
  }

  Future<void> _playNext() async {
    // Play the next song in the playlist
    if (!widget.isFromRecent) {
      // If in the playlist, play the next song in the playlist
      if (currentIndex < currentPlaylist.length - 1) {
        setState(() {
          currentIndex++;
        });
        await _initializePlayer();
      } else {
        // Optionally loop back to the first song in the playlist
        setState(() {
          currentIndex = 0; // Uncomment to loop back to the first song in the playlist
        });
        await _initializePlayer();
      }
    } else {
      // If in the favorites, play the next song in the favorites
      if (currentIndex < favoriteNotifier.value.length - 1) {
        setState(() {
          currentIndex++;
        });
        await _initializePlayer();
      } else {
        // Optionally loop back to the first song in favorites
        setState(() {
          currentIndex = 0; // Uncomment to loop back to the first favorite
        });
        await _initializePlayer();
      }
    }
  }

  Future<void> _playPrevious() async {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      await _initializePlayer();
      _updateFavoriteState();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    isPlayingNotifier.dispose();
    durationNotifier.dispose();
    positionNotifier.dispose();
    isFavoriteNotifier.dispose();
    favoriteNotifier.removeListener(_updateFavoriteState);
    super.dispose();
  }

  void _addToPlaylist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlaylistScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Playing Now"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 1) _addToPlaylist();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Add to Playlist"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              child: QueryArtworkWidget(
                id: currentPlaylist[currentIndex].id!,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentPlaylist[currentIndex].songTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              currentPlaylist[currentIndex].artist,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<Duration>(
              valueListenable: positionNotifier,
              builder: (context, position, _) {
                return ValueListenableBuilder<Duration>(
                  valueListenable: durationNotifier,
                  builder: (context, duration, _) {
                    return Column(
                      children: [
                        Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          value: position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final newPosition = Duration(seconds: value.toInt());
                            await _audioPlayer.seek(newPosition);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: isPlayingNotifier,
              builder: (context, isPlaying, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: _playPrevious,
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: _playPause,
                      iconSize: 64,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: _playNext,
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: isFavoriteNotifier,
                      builder: (context, isFavorite, _) {
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.blue : Colors.white,
                          ),
                          onPressed: () async {
                            await _toggleFavorite();
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _playPause() {
    if (isPlayingNotifier.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }
}