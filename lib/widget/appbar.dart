import 'package:flutter/material.dart';
import 'dart:ui';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color backgroundColor;

  const CustomAppBar({super.key, required this.title, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: backgroundColor.withOpacity(1),
            ),
          ),
        ),
        AppBar(
          title: title,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
            
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/seputipy.appspot.com/o/covers%2Fanimek.jpg?alt=media',
                  ),
                  radius: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
