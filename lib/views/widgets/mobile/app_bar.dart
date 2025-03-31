import 'package:flutter/material.dart';
import 'dart:ui';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color iconColor;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.iconColor,
    required this.fontColor,
    required this.fontSize,
    required this.fontWeight,
    required this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.1),
                  Color.fromRGBO(255, 255, 255, 0.2),
                ],
              ),
            ),
          ),
          titleSpacing: 0,
          title: Text(
            title,
            style: TextStyle(
              color: fontColor,
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back_rounded, size: 30, color: iconColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
