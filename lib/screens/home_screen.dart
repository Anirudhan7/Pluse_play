import 'package:flutter/material.dart';
import 'package:pluseplay/database/function/hive_store.dart';
import 'package:pluseplay/database/function/internal_storage.dart';
import 'package:pluseplay/database/function/recent_play/recent_play.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';
import 'package:pluseplay/screens/allsongs/allsongs.dart';
import 'package:pluseplay/screens/favourites/favorites_screen.dart';
import 'package:pluseplay/screens/playList/playlist.dart';
import 'package:pluseplay/screens/search/search.dart';
import 'package:pluseplay/screens/settings/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pluseplay/screens/widgets/all_songs_widget.dart';
import 'package:pluseplay/screens/nowPlaying/now_play.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/screens/widgets/nav_bar.dart';
import 'package:pluseplay/screens/widgets/recent_play_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const SearchPage(),
    FavoritesScreen(),
    PlaylistScreen()
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetch();
    await getAllSongs();
    await getRecentPlays();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _selectedIndex == 0
            ? AppBar(
                backgroundColor: const Color.fromARGB(255, 13, 3, 56),
                title: const Text(
                  "PulsePlay",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    },
                  ),
                ],
              )
            : null,
        body: _screens[_selectedIndex],
        backgroundColor: Colors.black,
        bottomNavigationBar: CurvedNavBar(
          selectedIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Songs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllSongsPage()),
                    );
                  },
                  child: const Text("See More",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<AllSongModel>>(
              valueListenable: allSongNotifier,
              builder: (context, allSongs, child) {
                return SizedBox(
                  height: 160,
                  child: allSongs.isEmpty
                      ? const Center(
                          child: Text(
                            "No Songs Found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: allSongs.length,
                          itemBuilder: (context, index) {
                            final song = allSongs[index];
                            return GestureDetector(
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
                            );
                          },
                        ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Recent Plays",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            RecentPlaysWidget(),
            const SizedBox(height: 24),
            const Text(
              "Artists",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _buildArtistCards(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildArtistCards() {
    Set<String> uniqueArtists = {};
    List<Widget> artistCards = [];

    for (var song in allSongNotifier.value) {
      if (uniqueArtists.add(song.artist)) {
        artistCards.add(ArtistCard(artistName: song.artist));
      }
    }

    return artistCards;
  }
}

class ArtistCard extends StatelessWidget {
  final String artistName;

  const ArtistCard({Key? key, required this.artistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArtistDetailScreen(artistName: artistName)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 100,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            artistName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ArtistDetailScreen extends StatelessWidget {
  final String artistName;

  const ArtistDetailScreen({Key? key, required this.artistName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          artistName,
          style: const TextStyle(
            color: Colors.white, // Set text color to white
            fontSize: 20, // Increase font size
            fontWeight: FontWeight.bold, // Make it bold
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 13, 3, 56), // Set a dark background color
      ),
      body: Container(
        color: const Color.fromARGB(
            255, 12, 5, 144), // Set a dark background color for the body
        child: ValueListenableBuilder<List<AllSongModel>>(
          valueListenable: allSongNotifier,
          builder: (context, allSongs, child) {
            final artistSongs =
                allSongs.where((song) => song.artist == artistName).toList();
            return artistSongs.isEmpty
                ? const Center(
                    child: Text(
                      "No Songs Found",
                      style: TextStyle(
                          color: Colors.white), // Ensure text is white
                    ),
                  )
                : ListView.builder(
                    itemCount: artistSongs.length,
                    itemBuilder: (context, index) {
                      final song = artistSongs[index];
                      return ListTile(
                        title: Text(
                          song.songTitle,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: const TextStyle(
                            color: Colors.grey,
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
    );
  }
}
