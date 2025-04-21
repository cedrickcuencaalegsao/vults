import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:vults/core/constants/constant_string.dart';

class GuestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> menuItems;
  final Function(int)? onMenuItemTap;
  final VoidCallback? onLoginTap;
  final int activeIndex;

  const GuestAppBar({
    super.key,
    this.title = 'Vults',
    this.menuItems = const ['Home', 'Features', 'About', 'Contact'],
    this.onMenuItemTap,
    this.onLoginTap,
    this.activeIndex = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [
            for (int i = 0; i < menuItems.length; i++)
              _buildMenuItem(context, menuItems[i], i),
            _buildActionButton(
              'Login',
              ConstantString.orange,
              ConstantString.white,
              onLoginTap ?? () {},
            ),
            const SizedBox(width: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, int index) {
    final bool isActive = index == activeIndex;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () {
            if (onMenuItemTap != null) {
              onMenuItemTap!(index);
            }
          },
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 4,
                width: 4,
                decoration: BoxDecoration(
                  color: isActive ? ConstantString.orange : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Responsive version for different screen sizes
class ResponsiveGuestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> menuItems;
  final Function(int)? onMenuItemTap;
  final VoidCallback? onLoginTap;
  final int activeIndex;

  const ResponsiveGuestAppBar({
    Key? key,
    this.title = 'Vults',
    this.menuItems = const ['Home', 'Features', 'About', 'Contact'],
    this.onMenuItemTap,
    this.onLoginTap,
    this.activeIndex = 0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width > 1000) {
      return GuestAppBar(
        title: title,
        menuItems: menuItems,
        onMenuItemTap: onMenuItemTap,
        onLoginTap: onLoginTap,
        activeIndex: activeIndex,
      );
    } else {
      return _MobileGuestAppBar(
        title: title,
        menuItems: menuItems,
        onMenuItemTap: onMenuItemTap,
        onLoginTap: onLoginTap,
        activeIndex: activeIndex,
      );
    }
  }
}

class _MobileGuestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<String> menuItems;
  final Function(int)? onMenuItemTap;
  final VoidCallback? onLoginTap;
  final int activeIndex;

  const _MobileGuestAppBar({
    Key? key,
    required this.title,
    required this.menuItems,
    this.onMenuItemTap,
    this.onLoginTap,
    this.activeIndex = 0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _showDrawer(context);
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  void _showDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }
}

// Drawer for mobile view
class GuestAppBarDrawer extends StatelessWidget {
  final List<String> menuItems;
  final Function(int)? onMenuItemTap;
  final VoidCallback? onLoginTap;
  final int activeIndex;

  const GuestAppBarDrawer({
    Key? key,
    required this.menuItems,
    this.onMenuItemTap,
    this.onLoginTap,
    this.activeIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      elevation: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
              for (int i = 0; i < menuItems.length; i++)
                _buildMenuItem(context, menuItems[i], i),
              const SizedBox(height: 40),
              _buildActionButton(
                'Login',
                ConstantString.orange,
                ConstantString.white,
                () {
                  Navigator.pop(context);
                  if (onLoginTap != null) onLoginTap!();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, int index) {
    final bool isActive = index == activeIndex;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (onMenuItemTap != null) {
            onMenuItemTap!(index);
          }
        },
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: ConstantString.orange,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(right: 10),
              ),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
