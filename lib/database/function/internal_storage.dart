import 'package:on_audio_query/on_audio_query.dart';
import 'package:pluseplay/database/function/hive_store.dart';


Future<void> fetch() async {
  final audioquery = OnAudioQuery();
  bool permissionStatus = await audioquery.permissionsStatus();
  
  if (!permissionStatus) {
    permissionStatus = await audioquery.permissionsRequest();
  }

  if (permissionStatus) {
    List<SongModel> songs1 = await audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    List<SongModel> mp3Songs = songs1.where((song) => song.data.endsWith('.mp3')).toList();
    await addToAllsong(mp3Songs);
    print(",,,,,, $mp3Songs");
  } else {
    print("Permission denied");
  }
}

// Future<void> fetch() async {
//   final audioquery = OnAudioQuery();
//   List<SongModel> songs1 = await audioquery.querySongs(
//     sortType: null,
//     orderType: OrderType.ASC_OR_SMALLER,
//     uriType: UriType.EXTERNAL,
//     ignoreCase: true,
//   );
//   List<SongModel> mp3Songs = songs1.where((song) => song.data.endsWith('.mp3')).toList();
//   await addToAllsong(mp3Songs);

//   print(",,,,,, $mp3Songs");
// }