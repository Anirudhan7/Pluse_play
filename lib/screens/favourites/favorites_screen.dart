import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/favourite/favourite.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';
import 'package:on_audio_query/on_audio_query.dart'; // Import for QueryArtworkWidget
import 'package:pluseplay/database/function/playlists/plaListfunc.dart'; // Import for playlist functions
import 'package:pluseplay/database/models/playlist/playList.dart'; // Import for Playlist model

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    getAllSongsFromFavorites(); 
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 15, 1, 77),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<FavoriteModel>>(
        valueListenable: favoriteNotifier,
        builder: (context, favoriteSongs, child) {
          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Text(
                "No favorites yet!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
             
              if (index < 0 || index >= favoriteSongs.length) {
                return const SizedBox.shrink(); 
              }

              final song = favoriteSongs[index];
              return Dismissible(
                key: Key(song.id.toString()),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await deleteFromFavorites(song.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${song.songTitle} removed from favorites')),
                  );
                },
                child: Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: QueryArtworkWidget(
                      id: song.id!,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: Text(
                      song.songTitle,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      // Navigate to the PlayingNow screen when the song is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayingNow(
                            song: song, // Pass the song to the PlayingNow screen
                            allSongs: favoriteSongs, // Pass the list of favorite songs
                            recentPlays: [], // You can pass recent plays if needed
                            isFromRecent: false, // Set this based on your logic
                          ),
                        ),
                      );
                    },
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'add_to_playlist',
                            child: Text('Add to Playlist'),
                          ),
                        ];
                      },
                      onSelected: (String value) async {
                        if (value == 'add_to_playlist') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Select Playlist'),
                                content: ValueListenableBuilder<List<Playlist>>(
                                  valueListenable: playlistsNotifier,
                                  builder: (context, playlists, child) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children : playlists.map((playlist) {
                                          return ListTile(
                                            title: Text(playlist.name),
                                            onTap: () {
                                              final songToAdd = PlaylistSongModel(
                                                id: song.id!,
                                                songTitle: song.songTitle,
                                                artist: song.artist,
                                                uri: song.uri ?? '', // Provide a default value if null
                                                imageUri: song.imageUri,
                                                songPath: song.songPath,
                                              );

                                              // Ensure playlist.id is not null
                                              if (playlist.id != null) {
                                                addSongToPlaylist(playlist.name, songToAdd);
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Playlist ID is null')),
                                                );
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}