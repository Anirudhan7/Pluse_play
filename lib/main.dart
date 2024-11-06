import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pluseplay/database/models/all_songs/all_song_model.dart';
import 'package:pluseplay/database/models/favourites/favourite_model.dart';
import 'package:pluseplay/database/models/playlist/playList.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';
import 'package:pluseplay/screens/splash_Screen.dart';
import 'package:pluseplay/database/function/playlists/plaListfunc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AllSongModelAdapter());
  Hive.registerAdapter(FavoriteModelAdapter());
  Hive.registerAdapter(PlaylistAdapter());
  Hive.registerAdapter(PlaylistSongModelAdapter());
  Hive.registerAdapter(RecentPlayModelAdapter());

  await getPlaylists();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
