import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/web/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Dashboard View
class DashboardView extends BaseView {
  const DashboardView({super.key});

  Future<List<Map<String, dynamic>>> _getRecentTransactions() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('timestamp', descending: true)
            .limit(3)
            .get();

    return Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data();

        // Get sender details
        final senderDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(data['fromUserId'])
                .get();
        final senderData = senderDoc.data() ?? {};

        // Get receiver details
        final receiverDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(data['toUserId'])
                .get();
        final receiverData = receiverDoc.data() ?? {};

        return {
          'id': doc.id,
          'user':
              '${senderData['firstName'] ?? 'Unknown'} → ${receiverData['firstName'] ?? 'Unknown'}',
          'amount': '₱${(data['amount'] ?? 0).toStringAsFixed(2)}',
          'status': data['status'] ?? 'Pending',
          'date': DateFormat(
            'dd MMM',
          ).format((data['timestamp'] as Timestamp).toDate()),
        };
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('transactions').snapshots(),
          builder: (context, transactionSnapshot) {
            if (!userSnapshot.hasData || !transactionSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final totalUsers = userSnapshot.data!.docs.length;
            final totalTransactions = transactionSnapshot.data!.docs.length;

            // Calculate total transaction amount
            double totalAmount = 0;
            for (var doc in transactionSnapshot.data!.docs) {
              totalAmount +=
                  (doc.data() as Map<String, dynamic>)['amount'] ?? 0;
            }

            // Sample data for the dashboard
            final List<Map<String, dynamic>> _recentTransactions = [
              {
                'id': '#001',
                'user': 'John Doe',
                'amount': '\$120.00',
                'status': 'Completed',
                'date': '22 Apr',
              },
              {
                'id': '#002',
                'user': 'Jane Smith',
                'amount': '\$85.50',
                'status': 'Pending',
                'date': '21 Apr',
              },
              {
                'id': '#003',
                'user': 'Robert Johnson',
                'amount': '\$200.00',
                'status': 'Failed',
                'date': '20 Apr',
              },
            ];

            final List<Map<String, dynamic>> _quickStats = [
              {
                'title': 'Total Users',
                'value': '$totalUsers',
                'icon': Icons.people,
                'color': ConstantString.lightBlue,
              },
              {
                'title': 'Transactions',
                'value': '$totalTransactions',
                'icon': Icons.swap_horiz,
                'color': ConstantString.green,
              },
              {
                'title': 'Total Transaction Volume',
                'value': '₱${totalAmount.toStringAsFixed(2)}',
                'icon': Icons.attach_money,
                'color': ConstantString.orange,
              },
              {
                'title': 'Growth',
                'value': '+12%',
                'icon': Icons.trending_up,
                'color': ConstantString.green,
              },
            ];

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _getRecentTransactions(),
              builder: (context, recentTransactionsSnapshot) {
                if (!recentTransactionsSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final recentTransactions = recentTransactionsSnapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionHeader('Dashboard Overview'),
                      const SizedBox(height: 20),

                      // Quick Stats
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _quickStats.length,
                        itemBuilder: (context, index) {
                          final stat = _quickStats[index];
                          return _buildStatCard(stat);
                        },
                      ),

                      const SizedBox(height: 24),

                      // Recent Activity and Transactions in a Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent Transactions
                          Expanded(
                            flex: 3,
                            child: _buildRecentTransactionsCard(
                              recentTransactions,
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Quick Actions
                          Expanded(flex: 2, child: _buildQuickActionsCard()),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(stat['icon'], size: 24, color: stat['color']),
                ),
                const Spacer(),
                Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(child: Icon(Icons.more_horiz, size: 18)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              stat['value'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: ConstantString.fontFredoka,
                color: ConstantString.darkBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['title'],
              style: TextStyle(
                fontFamily: ConstantString.fontFredoka,
                color: ConstantString.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsCard(
    List<Map<String, dynamic>> recentTransactions,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstantString.fontFredoka,
                    color: ConstantString.darkBlue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to transactions view
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: ConstantString.lightBlue,
                      fontFamily: ConstantString.fontFredoka,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              itemBuilder: (context, index) {
                final txn = recentTransactions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: getStatusColor(txn['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      getStatusIcon(txn['status']),
                      color: getStatusColor(txn['status']),
                    ),
                  ),
                  title: Text(
                    txn['user'],
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${txn['id']} • ${txn['date']}',
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      color: ConstantString.grey,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        txn['amount'],
                        style: TextStyle(
                          fontFamily: ConstantString.fontFredoka,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(txn['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          txn['status'],
                          style: TextStyle(
                            fontFamily: ConstantString.fontFredoka,
                            color: getStatusColor(txn['status']),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    final List<Map<String, dynamic>> _quickActions = [
      {
        'title': 'Add User',
        'icon': Icons.person_add,
        'color': ConstantString.lightBlue,
      },
      {
        'title': 'New Transaction',
        'icon': Icons.add_card,
        'color': ConstantString.green,
      },
      {
        'title': 'Generate Report',
        'icon': Icons.summarize,
        'color': ConstantString.orange,
      },
      {
        'title': 'Support Tickets',
        'icon': Icons.help_center,
        'color': ConstantString.grey,
      },
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: ConstantString.fontFredoka,
                color: ConstantString.darkBlue,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _quickActions.length,
              itemBuilder: (context, index) {
                final action = _quickActions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: action['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(action['icon'], color: action['color']),
                  ),
                  title: Text(
                    action['title'],
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                foregroundColor: ConstantString.darkBlue,
              ),
              child: Text(
                'View All Actions',
                style: TextStyle(fontFamily: ConstantString.fontFredoka),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
