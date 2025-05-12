// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:vults/core/constants/constant_string.dart';

// class AnalyticsView extends StatefulWidget {
//   const AnalyticsView({Key? key}) : super(key: key);

//   @override
//   _AnalyticsScreenState createState() => _AnalyticsScreenState();
// }

// class _AnalyticsScreenState extends State<AnalyticsView> {
//   String _selectedDateRange = 'Last 7 Days';
//   String _selectedAccountType = 'All';

//   final List<TransactionData> _transactionData = [
//     TransactionData('Mon', 2500),
//     TransactionData('Tue', 3200),
//     TransactionData('Wed', 2800),
//     TransactionData('Thu', 4100),
//     TransactionData('Fri', 3700),
//     TransactionData('Sat', 2900),
//     TransactionData('Sun', 3500),
//   ];

//   final List<AccountData> _accountData = [
//     AccountData('Savings', 35, Colors.blue),
//     AccountData('Checking', 25, Colors.green),
//     AccountData('Fixed Deposit', 20, Colors.orange),
//     AccountData('Business', 20, Colors.purple),
//   ];

//   Future<Map<String, dynamic>> _getAnalyticsData() async {
//     final usersRef = FirebaseFirestore.instance.collection('users');
//     final transactionsRef = FirebaseFirestore.instance.collection(
//       'transactions',
//     );

//     // Get total users
//     final totalUsers = (await usersRef.count().get()).count;

//     // Get active users (users who made transactions in last 30 days)
//     final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
//     final activeUsers = (await transactionsRef
//         .where('timestamp', isGreaterThan: thirtyDaysAgo)
//         .get()
//         .then(
//           (snap) =>
//               snap.docs.map((doc) => doc.get('fromUserId')).toSet().length,
//         ));

//     // Get transactions data
//     final transactionSnap =
//         await transactionsRef.orderBy('timestamp', descending: true).get();

//     double totalVolume = 0;
//     Map<String, double> dailyTotals = {};

//     for (var doc in transactionSnap.docs) {
//       final data = doc.data();
//       final amount = (data['amount'] as num).toDouble();
//       final timestamp = (data['timestamp'] as Timestamp).toDate();
//       final dateKey = DateFormat(
//         'EEE',
//       ).format(timestamp); // Get day name (Mon, Tue, etc)

//       totalVolume += amount;
//       dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + amount;
//     }

//     // Get account distribution
//     final accountTypesSnap =
//         await usersRef.where('accountTypes', isNull: false).get();

//     Map<String, int> accountDistribution = {};
//     for (var doc in accountTypesSnap.docs) {
//       final types = List<String>.from(doc['accountTypes'] ?? []);
//       for (var type in types) {
//         accountDistribution[type] = (accountDistribution[type] ?? 0) + 1;
//       }
//     }

//     return {
//       'totalUsers': totalUsers,
//       'activeUsers': activeUsers,
//       'totalTransactions': transactionSnap.docs.length,
//       'totalVolume': totalVolume,
//       'dailyTotals': dailyTotals,
//       'accountDistribution': accountDistribution,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         // First stream for users
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, userSnapshot) {
//           return StreamBuilder<QuerySnapshot>(
//             // Second stream for transactions
//             stream:
//                 FirebaseFirestore.instance
//                     .collection('transactions')
//                     .orderBy('timestamp', descending: true)
//                     .limit(100)
//                     .snapshots(),
//             builder: (context, transactionSnapshot) {
//               if (!userSnapshot.hasData || !transactionSnapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               // Calculate total users (excluding admin)
//               final totalUsers =
//                   userSnapshot.data!.docs.where((doc) {
//                     final data = doc.data() as Map<String, dynamic>;
//                     // Count all users with valid email, including admin
//                     return data['email'] != null &&
//                         data['email'].toString().isNotEmpty;
//                   }).length;

//               // Calculate active users
//               final thirtyDaysAgo = DateTime.now().subtract(
//                 const Duration(days: 30),
//               );

//               // Remove the unused activeTransactionUserIds calculation

//               // Replace the active users calculation with this simpler version
//               final activeUsers =
//                   userSnapshot.data!.docs.where((userDoc) {
//                     final userData = userDoc.data() as Map<String, dynamic>;
//                     final status =
//                         (userData['status'] as String?)?.toLowerCase() ?? '';

//                     // Debug print
//                     print('User ${userDoc.id} status: $status');

//                     // Simply check if status is active, same as User Management
//                     return status == 'active';
//                   }).length;

//               // Calculate analytics directly from snapshot
//               int totalTransactions = transactionSnapshot.data!.docs.length;
//               double totalVolume = 0;
//               Map<String, double> dailyTotals = {};

//               for (var doc in transactionSnapshot.data!.docs) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
//                 final timestamp = data['timestamp'] as Timestamp?;

//                 if (timestamp != null) {
//                   totalVolume += amount;
//                   final dateKey = DateFormat('EEE').format(timestamp.toDate());
//                   dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + amount;
//                 }
//               }

//               // Update transaction data for graph
//               _transactionData.clear();
//               dailyTotals.forEach((day, amount) {
//                 _transactionData.add(TransactionData(day, amount));
//               });

//               // Add this code before returning SingleChildScrollView
//               // Calculate totals by account type
//               Map<String, double> accountTypeTotals = {};

//               for (var doc in transactionSnapshot.data!.docs) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
//                 final accountType =
//                     data['accountType'] ??
//                     'Unknown'; // Get account type from transaction

//                 accountTypeTotals[accountType] =
//                     (accountTypeTotals[accountType] ?? 0) + amount;
//               }

//               // Update account data for pie chart
//               _accountData.clear();
//               final accountColors = {
//                 'Savings': Colors.blue,
//                 'Checking': Colors.green,
//                 'Fixed Deposit': Colors.orange,
//                 'Business': Colors.purple,
//               };

//               accountTypeTotals.forEach((type, amount) {
//                 _accountData.add(
//                   AccountData(type, amount, accountColors[type] ?? Colors.grey),
//                 );
//               });

//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeader(),
//                     const SizedBox(height: 24),
//                     _buildFilters(),
//                     const SizedBox(height: 24),
//                     GridView.count(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 16,
//                       mainAxisSpacing: 16,
//                       shrinkWrap: true,
//                       childAspectRatio: 2,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         _buildMetricCard(
//                           'Total Users',
//                           totalUsers
//                               .toString(), // Now shows correct total users
//                           Icons.people,
//                           Colors.blue,
//                           '',
//                         ),
//                         _buildMetricCard(
//                           'Active Users',
//                           activeUsers.toString(),
//                           Icons.person,
//                           Colors.green,
//                           '',
//                         ),
//                         _buildMetricCard(
//                           'Total Transactions',
//                           totalTransactions.toString(),
//                           Icons.receipt_long,
//                           Colors.orange,
//                           '',
//                         ),
//                         _buildMetricCard(
//                           'Transaction Volume',
//                           '₱${totalVolume.toStringAsFixed(2)}',
//                           Icons.attach_money,
//                           Colors.purple,
//                           '',
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 32),
//                     _buildCharts(),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Analytics',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             fontFamily: ConstantString.fontFredokaOne,
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: const Icon(Icons.download, size: 20),
//           label: Text(
//             'Print Reports',
//             style: TextStyle(fontFamily: ConstantString.fontFredoka),
//           ),
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//             minimumSize: const Size(100, 48),
//             elevation: 0,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilters() {
//     return Row(
//       children: [
//         DropdownButton<String>(
//           value: _selectedDateRange,
//           items:
//               ['Last 7 Days', 'Last 30 Days', 'Last 90 Days', 'This Year'].map((
//                 String value,
//               ) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//           onChanged: (String? newValue) {
//             if (newValue != null) {
//               setState(() {
//                 _selectedDateRange = newValue;
//               });
//             }
//           },
//         ),
//         const SizedBox(width: 16),
//         DropdownButton<String>(
//           value: _selectedAccountType,
//           items:
//               ['All', 'Savings', 'Checking', 'Fixed Deposit', 'Business'].map((
//                 String value,
//               ) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//           onChanged: (String? newValue) {
//             if (newValue != null) {
//               setState(() {
//                 _selectedAccountType = newValue;
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildMetricCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//     String trend,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: color),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontFamily: ConstantString.fontFredoka,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: ConstantString.fontFredoka,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             trend,
//             style: TextStyle(
//               color: Colors.green[600],
//               fontSize: 12,
//               fontFamily: ConstantString.fontFredoka,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCharts() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 3,
//           child: Container(
//             height: 400,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Transaction Trend',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: ConstantString.fontFredoka,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: SfCartesianChart(
//                     primaryXAxis: CategoryAxis(),
//                     series: <CartesianSeries<TransactionData, String>>[
//                       AreaSeries<TransactionData, String>(
//                         dataSource: _transactionData,
//                         xValueMapper: (TransactionData data, _) => data.day,
//                         yValueMapper: (TransactionData data, _) => data.amount,
//                         gradient: LinearGradient(
//                           colors: [
//                             ConstantString.lightBlue.withOpacity(0.3),
//                             ConstantString.lightBlue.withOpacity(0.1),
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                       LineSeries<TransactionData, String>(
//                         dataSource: _transactionData,
//                         xValueMapper: (TransactionData data, _) => data.day,
//                         yValueMapper: (TransactionData data, _) => data.amount,
//                         color: ConstantString.lightBlue,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           flex: 2,
//           child: Container(
//             height: 400,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Account Distribution',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: ConstantString.fontFredoka,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: SfCircularChart(
//                     series: <CircularSeries<AccountData, String>>[
//                       DoughnutSeries<AccountData, String>(
//                         dataSource: _accountData,
//                         xValueMapper: (AccountData data, _) => data.type,
//                         yValueMapper: (AccountData data, _) => data.amount,
//                         pointColorMapper: (AccountData data, _) => data.color,
//                         dataLabelSettings: DataLabelSettings(
//                           isVisible: true,
//                           labelPosition: ChartDataLabelPosition.outside,
//                           builder: (
//                             dynamic data,
//                             dynamic point,
//                             dynamic series,
//                             int pointIndex,
//                             int seriesIndex,
//                           ) {
//                             return Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(4),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.1),
//                                     spreadRadius: 1,
//                                     blurRadius: 2,
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 '₱${data.amount.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 12,
//                                   fontFamily: ConstantString.fontFredoka,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         // Remove legendItemText and use these instead
//                         name: 'Account Types',
//                         legendIconType: LegendIconType.circle,
//                         enableTooltip: true,
//                       ),
//                     ],
//                     legend: Legend(
//                       isVisible: true,
//                       position: LegendPosition.bottom,
//                       overflowMode: LegendItemOverflowMode.wrap,
//                     ),
//                     tooltipBehavior: TooltipBehavior(enable: true),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TransactionData {
//   final String day;
//   final double amount;

//   TransactionData(this.day, this.amount);
// }

// class AccountData {
//   final String type;
//   final double amount; // Changed from percentage to amount
//   final Color color; // Add color for consistent account type colors

//   AccountData(this.type, this.amount, this.color);
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vults/core/constants/constant_string.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsView> {
  String _selectedDateRange = 'Last 7 Days';
  String _selectedAccountType = 'All';

  final List<TransactionData> _transactionData = [
    TransactionData('Mon', 2500),
    TransactionData('Tue', 3200),
    TransactionData('Wed', 2800),
    TransactionData('Thu', 4100),
    TransactionData('Fri', 3700),
    TransactionData('Sat', 2900),
    TransactionData('Sun', 3500),
  ];

  final List<AccountData> _accountData = [
    AccountData('Savings', 35, Colors.blue),
    AccountData('Checking', 25, Colors.green),
    AccountData('Fixed Deposit', 20, Colors.orange),
    AccountData('Business', 20, Colors.purple),
  ];

  // Account colors map for consistent coloring - with both uppercase and lowercase variants
  final Map<String, Color> accountColors = {
    'Savings': Colors.blue,
    'savings': Colors.blue,
    'Checking': Colors.green,
    'checking': Colors.green,
    'Fixed Deposit': Colors.orange,
    'fixed_deposit': Colors.orange,
    'Business': Colors.purple,
    'business': Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    // No need to initialize with default data as we'll normalize on the fly
  }

  // Normalize account type to handle case sensitivity and formatting differences
  String _normalizeAccountType(String type) {
    // Convert underscores to spaces and capitalize first letter of each word
    String normalized = type.replaceAll('_', ' ');

    // Capitalize first letter of each word
    normalized = normalized
        .split(' ')
        .map((word) {
          if (word.isNotEmpty) {
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }
          return word;
        })
        .join(' ');

    return normalized;
  }

  // Update account data based on transactions
  void _updateAccountData(Map<String, double> accountTypeTotals) {
    // Clear existing data
    _accountData.clear();

    // Normalize and merge account types by combining amounts for variations of the same account type
    Map<String, double> normalizedTotals = {};
    Set<String> processedTypes = {};

    // Step 1: Normalize all account types and combine their amounts
    accountTypeTotals.forEach((type, amount) {
      String normalizedType = _normalizeAccountType(type);
      normalizedTotals[normalizedType] =
          (normalizedTotals[normalizedType] ?? 0.0) + amount;
      processedTypes.add(normalizedType);
    });

    // Step 2: Add all normalized account types with their combined amounts
    final standardTypes = ['Savings', 'Checking', 'Fixed Deposit', 'Business'];

    // Add standard types first (even if zero)
    for (final type in standardTypes) {
      final amount = normalizedTotals[type] ?? 0.0;
      _accountData.add(
        AccountData(type, amount, _getColorForAccountType(type)),
      );
      processedTypes.remove(type); // Remove from processed to avoid duplication
    }

    // Add any remaining types that aren't in our standard list
    for (final type in processedTypes) {
      _accountData.add(
        AccountData(
          type,
          normalizedTotals[type]!,
          _getColorForAccountType(type),
        ),
      );
    }
  }

  // Get color for account type (handles normalized types)
  Color _getColorForAccountType(String type) {
    // Standard colors for our main account types
    final standardColors = {
      'Savings': Colors.blue,
      'Checking': Colors.green,
      'Fixed Deposit': Colors.orange,
      'Business': Colors.purple,
    };

    return standardColors[type] ??
        Colors.grey; // Grey for any non-standard types
  }

  Future<Map<String, dynamic>> _getAnalyticsData() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final transactionsRef = FirebaseFirestore.instance.collection(
      'transactions',
    );

    // Get total users
    final totalUsers = (await usersRef.count().get()).count;

    // Get active users (users who made transactions in last 30 days)
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final activeUsers = (await transactionsRef
        .where('timestamp', isGreaterThan: thirtyDaysAgo)
        .get()
        .then(
          (snap) =>
              snap.docs.map((doc) => doc.get('fromUserId')).toSet().length,
        ));

    // Get transactions data
    final transactionSnap =
        await transactionsRef.orderBy('timestamp', descending: true).get();

    double totalVolume = 0;
    Map<String, double> dailyTotals = {};

    for (var doc in transactionSnap.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final timestamp = (data['timestamp'] as Timestamp).toDate();
      final dateKey = DateFormat(
        'EEE',
      ).format(timestamp); // Get day name (Mon, Tue, etc)

      totalVolume += amount;
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + amount;
    }

    // Get account distribution
    final accountTypesSnap =
        await usersRef.where('accountTypes', isNull: false).get();

    Map<String, int> accountDistribution = {};
    for (var doc in accountTypesSnap.docs) {
      final types = List<String>.from(doc['accountTypes'] ?? []);
      for (var type in types) {
        accountDistribution[type] = (accountDistribution[type] ?? 0) + 1;
      }
    }

    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'totalTransactions': transactionSnap.docs.length,
      'totalVolume': totalVolume,
      'dailyTotals': dailyTotals,
      'accountDistribution': accountDistribution,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // First stream for users
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            // Second stream for transactions
            stream:
                FirebaseFirestore.instance
                    .collection('transactions')
                    .orderBy('timestamp', descending: true)
                    .limit(100)
                    .snapshots(),
            builder: (context, transactionSnapshot) {
              if (!userSnapshot.hasData || !transactionSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Calculate total users (excluding admin)
              final totalUsers =
                  userSnapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    // Count all users with valid email, including admin
                    return data['email'] != null &&
                        data['email'].toString().isNotEmpty;
                  }).length;

              // Calculate active users
              final thirtyDaysAgo = DateTime.now().subtract(
                const Duration(days: 30),
              );

              // Replace the active users calculation with this simpler version
              final activeUsers =
                  userSnapshot.data!.docs.where((userDoc) {
                    final userData = userDoc.data() as Map<String, dynamic>;
                    final status =
                        (userData['status'] as String?)?.toLowerCase() ?? '';

                    // Debug print
                    print('User ${userDoc.id} status: $status');

                    // Simply check if status is active, same as User Management
                    return status == 'active';
                  }).length;

              // Calculate analytics directly from snapshot
              int totalTransactions = transactionSnapshot.data!.docs.length;
              double totalVolume = 0;
              Map<String, double> dailyTotals = {};

              for (var doc in transactionSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
                final timestamp = data['timestamp'] as Timestamp?;

                if (timestamp != null) {
                  totalVolume += amount;
                  final dateKey = DateFormat('EEE').format(timestamp.toDate());
                  dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + amount;
                }
              }

              // Update transaction data for graph
              _transactionData.clear();
              dailyTotals.forEach((day, amount) {
                _transactionData.add(TransactionData(day, amount));
              });

              // Calculate totals by account type
              Map<String, double> accountTypeTotals = {};

              for (var doc in transactionSnapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;
                final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

                // Get account type from transaction, convert to lowercase for consistency
                String accountType =
                    (data['accountType'] as String?) ?? 'unknown';

                // Add to totals
                accountTypeTotals[accountType] =
                    (accountTypeTotals[accountType] ?? 0) + amount;
              }

              // Update account data for pie chart using our normalization method
              _updateAccountData(accountTypeTotals);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildFilters(),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      childAspectRatio: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMetricCard(
                          'Total Users',
                          totalUsers
                              .toString(), // Now shows correct total users
                          Icons.people,
                          Colors.blue,
                          '',
                        ),
                        _buildMetricCard(
                          'Active Users',
                          activeUsers.toString(),
                          Icons.person,
                          Colors.green,
                          '',
                        ),
                        _buildMetricCard(
                          'Total Transactions',
                          totalTransactions.toString(),
                          Icons.receipt_long,
                          Colors.orange,
                          '',
                        ),
                        _buildMetricCard(
                          'Transaction Volume',
                          '₱${totalVolume.toStringAsFixed(2)}',
                          Icons.attach_money,
                          Colors.purple,
                          '',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildCharts(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Analytics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download, size: 20),
          label: Text(
            'Print Reports',
            style: TextStyle(fontFamily: ConstantString.fontFredoka),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(100, 48),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        DropdownButton<String>(
          value: _selectedDateRange,
          items:
              ['Last 7 Days', 'Last 30 Days', 'Last 90 Days', 'This Year'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedDateRange = newValue;
              });
            }
          },
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _selectedAccountType,
          items:
              ['All', 'Savings', 'Checking', 'Fixed Deposit', 'Business'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedAccountType = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String trend,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: ConstantString.fontFredoka,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantString.fontFredoka,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            trend,
            style: TextStyle(
              color: Colors.green[600],
              fontSize: 12,
              fontFamily: ConstantString.fontFredoka,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries<TransactionData, String>>[
                      AreaSeries<TransactionData, String>(
                        dataSource: _transactionData,
                        xValueMapper: (TransactionData data, _) => data.day,
                        yValueMapper: (TransactionData data, _) => data.amount,
                        gradient: LinearGradient(
                          colors: [
                            ConstantString.lightBlue.withOpacity(0.3),
                            ConstantString.lightBlue.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      LineSeries<TransactionData, String>(
                        dataSource: _transactionData,
                        xValueMapper: (TransactionData data, _) => data.day,
                        yValueMapper: (TransactionData data, _) => data.amount,
                        color: ConstantString.lightBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Account Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SfCircularChart(
                    series: <CircularSeries<AccountData, String>>[
                      DoughnutSeries<AccountData, String>(
                        dataSource: _accountData,
                        xValueMapper: (AccountData data, _) => data.type,
                        yValueMapper: (AccountData data, _) => data.amount,
                        pointColorMapper: (AccountData data, _) => data.color,
                        // Add explicit color for each segment
                        explodeAll: false, // For better visibility
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          connectorLineSettings: ConnectorLineSettings(
                            type: ConnectorType.line,
                            length: '15%',
                            width: 1,
                          ),
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                        ),
                        name: 'Account Types',
                        legendIconType: LegendIconType.circle,
                        enableTooltip: true,
                      ),
                    ],
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: const TextStyle(
                        fontFamily: ConstantString.fontFredoka,
                        fontSize: 12,
                      ),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionData {
  final String day;
  final double amount;

  TransactionData(this.day, this.amount);
}

class AccountData {
  final String type;
  final double amount; // Changed from percentage to amount
  final Color color; // Add color for consistent account type colors

  AccountData(this.type, this.amount, this.color);
}
