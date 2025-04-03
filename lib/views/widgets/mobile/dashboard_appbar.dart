import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'dart:ui';

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  DashboardAppBarState createState() => DashboardAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DashboardAppBarState extends State<DashboardAppBar> {
  void _navigate(BuildContext context, String nextRoute) {
    Navigator.pushNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.1),
        ),
      ),
    ),
      leading: IconButton(
        padding: const EdgeInsets.only(left: 20),
        icon: const Icon(
          Icons.menu_rounded,
          color: Colors.white, // Change color
          size: 45, // Change size
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ), // Remove the shadow
      title: const Text(
        ConstantString.appName,
        style: TextStyle(
          color: ConstantString.white,
          fontFamily: ConstantString.fontFredokaOne,
          fontSize: 30, // Set the title color to black for visibility
        ),
      ),

      actions: [
        IconButton(
          icon: const Icon(
            Icons.send_outlined,
            size: 25,
            color: ConstantString.white,
          ),
          onPressed: () => _navigate(context, "/sendmoney"),
        ),
        IconButton(
          icon: const Icon(
            Icons.qr_code_2_rounded,
            size: 30,
            color: ConstantString.white,
          ),
          onPressed: () => _navigate(context, "/scanqr"),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_active_outlined,
            size: 30,
            color: ConstantString.white,
          ),
          onPressed: () => _navigate(context, "/notification"),
        ),
        const SizedBox(width: 20), // Add some space between the icons
      ],
    );
  }
}
