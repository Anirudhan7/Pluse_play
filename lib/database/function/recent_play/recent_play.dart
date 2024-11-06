import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pluseplay/database/models/recent_play/recent_play.dart';

ValueNotifier<List<RecentPlayModel>> recentPlayNotifier = ValueNotifier([]);

Future<void> addRecentPlay(RecentPlayModel song) async {
  final openedBox = await Hive.openBox<RecentPlayModel>('recentlyPlayed');


  recentPlayNotifier.value.removeWhere((item) => item.id == song.id);
  
  recentPlayNotifier.value.add(song);

  if (openedBox.length >= 30) {
    await openedBox.deleteAt(0); 
  }

  await openedBox.put(song.id, song);


  final sortedList = openedBox.values.toList();
  sortedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  recentPlayNotifier.value = sortedList;

  recentPlayNotifier.notifyListeners();
}

Future<void> getRecentPlays() async {
  final openedBox = await Hive.openBox<RecentPlayModel>('recentlyPlayed');
  recentPlayNotifier.value.clear();


  final sortedList = openedBox.values.toList();
  sortedList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

  recentPlayNotifier.value = sortedList;
  recentPlayNotifier.notifyListeners();
}
