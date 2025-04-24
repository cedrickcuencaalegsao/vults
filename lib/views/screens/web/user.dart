import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/web/app.dart';

// Users View
class UsersView extends BaseView {
  const UsersView({super.key});

  final List<Map<String, dynamic>> _users = const [
    {'id': '001', 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Admin', 'status': 'Active'},
    {'id': '002', 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'User', 'status': 'Active'},
    {'id': '003', 'name': 'Robert Johnson', 'email': 'robert@example.com', 'role': 'User', 'status': 'Inactive'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionHeader('Users'),
          const SizedBox(height: 20),
          
          // Placeholder for users view
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Users View - Coming Soon',
                  style: TextStyle(
                    fontFamily: ConstantString.fontFredoka,
                    fontSize: 18,
                    color: ConstantString.darkBlue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}