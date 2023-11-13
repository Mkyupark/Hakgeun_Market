import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final String title;
  // final VoidCallback onSearchPressed;
  // final VoidCallback onMenuPressed;
  // final VoidCallback onNotificationPressed;

  // CustomAppBar({
  //   required this.title,
  //   required this.onSearchPressed,
  //   required this.onMenuPressed,
  //   required this.onNotificationPressed,
  // });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
Widget build(BuildContext context) {
  return AppBar(
    title: const Text(
      "학근 마켓",
      style: TextStyle(color: Colors.white), // Set text color to white
    ),
    backgroundColor: Colors.green, // Set background color to green
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {},
        color: Colors.white, // Set icon color to white
      ),
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {},
        color: Colors.white, // Set icon color to white
      ),
      IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {},
        color: Colors.white, // Set icon color to white
      ),
    ],
  );
}}