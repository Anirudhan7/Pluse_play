import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/playlists/plaListfunc.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';
import 'package:pluseplay/screens/playList/new_list.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
    getPlaylists(); // Fetch playlists when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Playlists',
            style: TextStyle(color: Colors.white), 
          ),
        ),
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
            return ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.blue),
                  title: Text(
                    playlist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistDetailScreen(playlistName: playlist.name),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Playlist"),
                          content: const Text("Are you sure you want to delete this playlist?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        await deletePlaylist(playlist.id!);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePlaylistDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 0, 150, 136), 
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController playlistNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Playlist'),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(hintText: "Playlist Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final playlistName = playlistNameController.text.trim();
                if (playlistName.isNotEmpty) {
                  await createPlaylist(playlistName: playlistName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}