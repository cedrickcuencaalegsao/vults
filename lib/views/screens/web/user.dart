import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/web/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// User Model
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  String status;
  bool isVerified;
  List<String> accountTypes;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.isVerified = false,
    this.accountTypes = const [],
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? status,
    bool? isVerified,
    List<String>? accountTypes,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      accountTypes: accountTypes ?? this.accountTypes,
    );
  }
}

// Users View
class UsersView extends BaseView {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return UserManagementContent(baseView: this);
  }
}

class UserManagementContent extends StatefulWidget {
  final UsersView baseView;

  const UserManagementContent({super.key, required this.baseView});

  @override
  State<UserManagementContent> createState() => _UserManagementContentState();
}

class _UserManagementContentState extends State<UserManagementContent> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _verificationFilter = 'All';

  // Update status options to match database values
  final List<String> _statusOptions = ['All', 'active', 'inactive', 'pending'];
  final List<String> _verificationOptions = ['All', 'Verified', 'Unverified'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      // First get regular users
      final usersSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('isAdmin', isEqualTo: false)
              .get();

      // Then get the specific admin user
      final adminDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc('NYTIwHlhWEh0r93qZKY6jgat5uu1')
              .get();

      setState(() {
        _users = [
          // Add admin user first
          if (adminDoc.exists)
            User(
              id: adminDoc.id,
              name:
                  '${adminDoc.data()?['firstName'] ?? ''} ${adminDoc.data()?['lastName'] ?? ''}'
                      .trim(),
              email: adminDoc.data()?['email'] ?? '',
              role: 'Admin',
              status: (adminDoc.data()?['status'] ?? 'active').toLowerCase(),
              isVerified: adminDoc.data()?['isVerified'] ?? true,
              accountTypes: List<String>.from(
                adminDoc.data()?['accountTypes'] ?? [],
              ),
            ),
          // Then add regular users
          ...usersSnapshot.docs.map((doc) {
            final data = doc.data();
            return User(
              id: doc.id,
              name:
                  '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim(),
              email: data['email'] ?? '',
              role: data['isAdmin'] == true ? 'Admin' : 'User',
              status: (data['status'] ?? 'pending').toLowerCase(),
              isVerified: data['isVerified'] ?? false,
              accountTypes: List<String>.from(data['accountTypes'] ?? []),
            );
          }).toList(),
        ];

        _filteredUsers = List.from(_users);
      });
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers =
          _users.where((user) {
            // Apply search filter
            final matchesSearch =
                user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                user.id.toLowerCase().contains(_searchQuery.toLowerCase());

            // Apply status filter
            final matchesStatus =
                _statusFilter == 'All' || user.status == _statusFilter;

            // Apply verification filter
            final matchesVerification =
                _verificationFilter == 'All' ||
                (_verificationFilter == 'Verified' && user.isVerified) ||
                (_verificationFilter == 'Unverified' && !user.isVerified);

            return matchesSearch && matchesStatus && matchesVerification;
          }).toList();
    });
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder:
          (context) => EditUserDialog(
            user: user,
            onSave: (updatedUser) {
              setState(() {
                final index = _users.indexWhere((u) => u.id == updatedUser.id);
                if (index != -1) {
                  _users[index] = updatedUser;
                  _filterUsers();
                }
              });
            },
          ),
    );
  }

  void _toggleVerification(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'isVerified': !user.isVerified,
      });

      setState(() {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = user.copyWith(isVerified: !user.isVerified);
          _filterUsers();
        }
      });
    } catch (e) {
      print('Error toggling verification: $e');
    }
  }

  void _changeStatus(User user, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'status': newStatus,
      });

      setState(() {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = user.copyWith(status: newStatus);
          _filterUsers();
        }
      });
    } catch (e) {
      print('Error changing status: $e');
    }
  }

  void _manageAccountTypes(User user) {
    showDialog(
      context: context,
      builder:
          (context) => AccountTypesDialog(
            user: user,
            onSave: (updatedUser) async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.id)
                    .update({'accountTypes': updatedUser.accountTypes});

                setState(() {
                  final index = _users.indexWhere(
                    (u) => u.id == updatedUser.id,
                  );
                  if (index != -1) {
                    _users[index] = updatedUser;
                    _filterUsers();
                  }
                });
              } catch (e) {
                print('Error updating account types: $e');
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Padding(
      padding: const EdgeInsets.only(
        top: 76.0,
      ), // Remove padding from outer container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Add horizontal padding only
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.baseView.buildSectionHeader('User Management'),
                const SizedBox(height: 20),
                _buildSearchAndFilters(isMobile),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      isMobile
                          ? _buildMobileUserList()
                          : _buildUsersDataTable(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      children: [
        // Search field
        SizedBox(
          width: isMobile ? double.infinity : 300,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterUsers();
              });
            },
          ),
        ),

        // Status filter
        SizedBox(
          width: isMobile ? double.infinity : 200,
          child: DropdownButtonFormField<String>(
            value: _statusFilter,
            decoration: InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            items:
                _statusOptions.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _statusFilter = value!;
                _filterUsers();
              });
            },
          ),
        ),

        // Verification filter
        SizedBox(
          width: isMobile ? double.infinity : 200,
          child: DropdownButtonFormField<String>(
            value: _verificationFilter,
            decoration: InputDecoration(
              labelText: 'Verification',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            items:
                _verificationOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _verificationFilter = value!;
                _filterUsers();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUsersDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade50),
        columns: const [
          DataColumn(label: const Text('ID')),
          DataColumn(label: const Text('Name')),
          DataColumn(label: const Text('Email')),
          DataColumn(label: const Text('Role')),
          DataColumn(label: const Text('Status')),
          DataColumn(label: const Text('Verified')),
          DataColumn(label: const Text('Account Types')),
          DataColumn(label: const Text('Actions')),
        ],
        rows:
            _filteredUsers.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user.id)),
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.role)),
                  DataCell(
                    DropdownButton<String>(
                      value: user.status,
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down, size: 16),
                      items:
                          ['active', 'inactive', 'pending'].map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Row(
                                children: [
                                  Icon(
                                    status == 'active'
                                        ? Icons.check_circle
                                        : status == 'inactive'
                                        ? Icons.cancel
                                        : Icons.pending,
                                    size: 16,
                                    color:
                                        status == 'active'
                                            ? Colors.green
                                            : status == 'inactive'
                                            ? Colors.red
                                            : Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    status[0].toUpperCase() +
                                        status.substring(1),
                                  ), // Capitalize for display
                                ],
                              ),
                            );
                          }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          _changeStatus(user, value);
                        }
                      },
                    ),
                  ),
                  DataCell(
                    Icon(
                      user.isVerified ? Icons.check_circle : Icons.cancel,
                      color: user.isVerified ? Colors.green : Colors.red,
                    ),
                  ),
                  DataCell(Text(user.accountTypes.join(', '))),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.account_balance_wallet),
                          onPressed: () => _manageAccountTypes(user),
                          tooltip: 'Manage Account Types',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editUser(user),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMobileUserList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredUsers.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final user = _filteredUsers[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: user.isVerified,
                activeColor: ConstantString.lightBlue,
                onChanged: (value) {
                  _toggleVerification(user);
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editUser(user),
              ),
            ],
          ),
          onTap: () => _showUserDetailsBottomSheet(user),
        );
      },
    );
  }

  void _showUserDetailsBottomSheet(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _detailRow('ID', user.id),
              _detailRow('Email', user.email),
              _detailRow('Role', user.role),
              _detailRow('Status', user.status),
              _detailRow('Verified', user.isVerified ? 'Yes' : 'No'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () {
                      Navigator.pop(context);
                      _editUser(user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantString.lightBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      user.isVerified ? Icons.unpublished : Icons.verified_user,
                    ),
                    label: Text(user.isVerified ? 'Unverify' : 'Verify'),
                    onPressed: () {
                      _toggleVerification(user);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          user.isVerified ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class EditUserDialog extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  const EditUserDialog({super.key, required this.user, required this.onSave});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _role;
  late String _status;
  late bool _isVerified;

  final List<String> _roles = ['Admin', 'User'];
  final List<String> _statusOptions = ['Active', 'Inactive', 'Pending'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _role = widget.user.role;
    _status = widget.user.status;
    _isVerified = widget.user.isVerified;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items:
                  _roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items:
                  _statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _status = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Verified'),
              value: _isVerified,
              onChanged: (value) {
                setState(() {
                  _isVerified = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedUser = widget.user.copyWith(
              name: _nameController.text,
              email: _emailController.text,
              role: _role,
              status: _status,
              isVerified: _isVerified,
            );
            widget.onSave(updatedUser);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ConstantString.lightBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Dialog for managing account types
class AccountTypesDialog extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  const AccountTypesDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  _AccountTypesDialogState createState() => _AccountTypesDialogState();
}

class _AccountTypesDialogState extends State<AccountTypesDialog> {
  late List<String> _selectedAccountTypes;

  final List<String> _availableAccountTypes = [
    'Fixed Deposit',
    'Business',
    'Savings',
    'Checking',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAccountTypes = List.from(widget.user.accountTypes);
  }

  void _toggleAccountType(String accountType) {
    setState(() {
      if (_selectedAccountTypes.contains(accountType)) {
        _selectedAccountTypes.remove(accountType);
      } else {
        _selectedAccountTypes.add(accountType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manage Account Types for '),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            _availableAccountTypes.map((accountType) {
              return CheckboxListTile(
                title: Text(accountType),
                value: _selectedAccountTypes.contains(accountType),
                onChanged: (bool? value) {
                  _toggleAccountType(accountType);
                },
              );
            }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedUser = widget.user.copyWith(
              accountTypes: _selectedAccountTypes,
            );
            widget.onSave(updatedUser);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
