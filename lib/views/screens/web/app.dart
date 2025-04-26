import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/web/admin_dashboard.dart';
import 'package:vults/views/screens/web/transaction.dart';
import 'package:vults/views/screens/web/user.dart';

// App Container Widget
class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  AppContainerState createState() => AppContainerState();
}

class AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;

  // Navigation items
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard, 'title': 'Dashboard'},
    {'icon': Icons.swap_horiz, 'title': 'Transactions'},
    {'icon': Icons.people, 'title': 'Users'},
    {'icon': Icons.bar_chart, 'title': 'Analytics'},
    // Settings option removed as per user request
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're on a mobile device
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          // Side navigation for larger screens
          if (!isMobile) _buildSideNavigation(),

          // Main content
          Expanded(child: _getBody()),
        ],
      ),
      bottomNavigationBar: isMobile ? _buildBottomNavBar() : null,
    );
  }

  bool _shouldShowFAB() {
    // Show FAB for transactions and users screens
    return _selectedIndex == 1 || _selectedIndex == 2;
  }

  Widget _buildSideNavigation() {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Admin Panel',
                style: TextStyle(
                  fontFamily: ConstantString.fontFredokaOne,
                  fontSize: 18,
                  color: ConstantString.darkBlue,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                return _buildNavItem(
                  icon: _navItems[index]['icon'],
                  title: _navItems[index]['title'],
                  index: index,
                );
              },
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontFamily: ConstantString.fontFredoka,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: ConstantString.darkBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ConstantString.darkBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Admin User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                Text(
                  'admin@vults.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(
            _navItems.length,
            (index) => _buildNavItem(
              icon: _navItems[index]['icon'],
              title: _navItems[index]['title'],
              index: index,
              isDrawer: true,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontFamily: ConstantString.fontFredoka,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: ConstantString.lightBlue,
      unselectedItemColor: Colors.grey,
      items:
          _navItems
              .take(5) // Limit to 5 items for bottom nav
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item['icon']),
                  label: item['title'],
                ),
              )
              .toList(),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
    bool isDrawer = false,
  }) {
    final bool isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected
                ? ConstantString.lightBlue
                : isDrawer
                ? null
                : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? ConstantString.lightBlue : null,
          fontFamily: ConstantString.fontFredoka,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => _onItemTapped(index),
      tileColor:
          isSelected && !isDrawer
              ? ConstantString.lightBlue.withOpacity(0.1)
              : null,
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardView();
      case 1:
        return const TransactionsView();
      case 2:
        return const UsersView();
      case 3:
        return const Center(child: Text('Analytics View - Coming Soon'));
      default:
        return const DashboardView();
    }
  }
}

// Base view class with common functionality
abstract class BaseView extends StatelessWidget {
  const BaseView({super.key});

  Widget buildSectionHeader(String title, {bool showActions = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
            color: ConstantString.darkBlue,
          ),
        ),
        if (showActions)
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('April 2025'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: ConstantString.darkBlue,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {},
                tooltip: 'Refresh',
              ),
            ],
          ),
      ],
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return ConstantString.green;
      case 'Pending':
        return ConstantString.orange;
      case 'Failed':
        return ConstantString.red;
      default:
        return ConstantString.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'Pending':
        return Icons.pending;
      case 'Failed':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
