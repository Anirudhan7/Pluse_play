import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CurvedNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.black,
      color: const Color.fromARGB(255, 27, 9, 163),
      items: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.search, color: Colors.white),
        Icon(Icons.favorite, color: Colors.white),
        Icon(Icons.library_music, color: Colors.white),
      ],
      onTap: onTap,
      height: 60,
    );
  }
}