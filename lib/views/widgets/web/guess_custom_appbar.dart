import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'dart:ui';

class GuessCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const GuessCustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: ConstantString.fontFredokaOne,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
    // return AppBar(

    // );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
