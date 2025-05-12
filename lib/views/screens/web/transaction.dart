import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/web/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Transactions View
class TransactionsView extends BaseView {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('transactions')
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = snapshot.data!.docs;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader('Transactions'),
              const SizedBox(height: 20),

              // Search and filter row
              _buildSearchAndFilterRow(),

              const SizedBox(height: 20),

              // Transactions table
              _buildTransactionsTable(transactions),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.filter_list),
          label: Text('Filter'),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(100, 48),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          icon: const Icon(Icons.download),
          label: Text('Export'),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            minimumSize: const Size(100, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsTable(List<DocumentSnapshot> transactions) {
    // Add debug print before return statement
    debugPrint('Total transactions: ${transactions.length}');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Transaction ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredoka,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'From',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredoka,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'To',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredoka,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredoka,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredoka,
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     'Status',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontFamily: ConstantString.fontFredoka,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Table rows
            for (var transaction in transactions)
              FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.wait([
                  _getUserDetails(_getSenderId(transaction)),
                  _getUserDetails(_getReceiverId(transaction)),
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final transactionData =
                      transaction.data() as Map<String, dynamic>;
                  print('Full transaction data: $transactionData');

                  final senderDetails = snapshot.data![0];
                  final receiverDetails = snapshot.data![1];

                  // Add these lines to define timestamp and amount
                  final timestamp = _getTimestamp(transactionData);
                  final amount = _getAmount(transactionData);

                  final fromUserId = _getSenderId(transaction);
                  final toUserId = _getReceiverId(transaction);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        // SizedBox(
                        //   width: 40,
                        //   child: Checkbox(value: false, onChanged: (value) {}),
                        // ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            transaction.id,
                            style: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            fromUserId.isEmpty ? 'Unknown' : fromUserId,
                            style: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            toUserId.isEmpty ? 'Unknown' : toUserId,
                            style: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            timestamp != null
                                ? DateFormat(
                                  'dd MMM yyyy',
                                ).format(timestamp.toDate())
                                : 'No date',
                            style: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '₱${amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: ConstantString.fontFredoka,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: 8,
                        //       vertical: 2,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: getStatusColor(status).withOpacity(0.1),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Text(
                        //       status,
                        //       style: TextStyle(
                        //         fontFamily: ConstantString.fontFredoka,
                        //         color: getStatusColor(status),
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              ),

            // Pagination
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  void showTransactionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: Text('View Details'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text('Edit Transaction'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing 1 to 5 of 100 entries',
            style: TextStyle(
              fontFamily: ConstantString.fontFredoka,
              color: ConstantString.grey,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {},
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ConstantString.lightBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: ConstantString.fontFredoka,
                    ),
                  ),
                ),
              ),
              for (int i = 2; i <= 3; i++)
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '$i',
                      style: TextStyle(fontFamily: ConstantString.fontFredoka),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods to handle different field names
  String _getSenderId(DocumentSnapshot transaction) {
    final data = transaction.data() as Map<String, dynamic>;
    print('Transaction data for sender: $data'); // Debug print
    return data['fromUserId'] ?? // Try this field first
        data['senderUid'] ??
        data['senderId'] ??
        data['uid'] ??
        '';
  }

  // Add this helper method to get receiver ID
  String _getReceiverId(DocumentSnapshot transaction) {
    final data = transaction.data() as Map<String, dynamic>;
    print('Transaction data for receiver: $data'); // Debug print
    return data['toUserId'] ?? // Try this field first
        data['receiverUid'] ??
        data['receiverId'] ??
        '';
  }

  double _getAmount(Map<String, dynamic> data) {
    return (data['amount'] ?? data['transactionAmount'] ?? data['value'] ?? 0.0)
        .toDouble();
  }

  String _getStatus(Map<String, dynamic> data) {
    return data['status'] ??
        data['transactionStatus'] ??
        data['state'] ??
        'Pending';
  }

  Timestamp? _getTimestamp(Map<String, dynamic> data) {
    return data['timestamp'] ?? data['date'] ?? data['createdAt'] ?? null;
  }

  // Update the user details fetching method
  Future<Map<String, dynamic>> _getUserDetails(String userId) async {
    try {
      print('Fetching user details for ID: $userId'); // Debug print
      if (userId.isEmpty) {
        print('User ID is empty'); // Debug print
        return {'firstName': 'Unknown', 'lastName': ''};
      }

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (!doc.exists) {
        print('No user document found for ID: $userId'); // Debug print
        return {'firstName': 'Unknown', 'lastName': ''};
      }

      final userData = doc.data() ?? {};
      print('Found user data: $userData'); // Debug print
      return userData;
    } catch (e) {
      print('Error fetching user details: $e');
      return {'firstName': 'Unknown', 'lastName': ''};
    }
  }
}
