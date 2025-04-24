import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/screens/web/app.dart';

// Transactions View
class TransactionsView extends BaseView {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
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
          _buildTransactionsTable(),
        ],
      ),
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

  Widget _buildTransactionsTable() {
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
                      'User',
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
                  Expanded(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: ConstantString.fontFredoka,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Table rows
            for (int i = 0; i < 5; i++)
              Container(
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
                    SizedBox(
                      width: 40,
                      child: Checkbox(value: false, onChanged: (value) {}),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '#TXN-${1000 + i}',
                        style: TextStyle(
                          fontFamily: ConstantString.fontFredoka,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'User ${['John Doe', 'Jane Smith', 'Robert Johnson'][i % 3]}',
                        style: TextStyle(
                          fontFamily: ConstantString.fontFredoka,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${20 + i} Apr 2025',
                        style: TextStyle(
                          fontFamily: ConstantString.fontFredoka,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '\$${(i + 1) * 75}.00',
                        style: TextStyle(
                          fontFamily: ConstantString.fontFredoka,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(
                            ['Completed', 'Pending', 'Failed'][i % 3],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ['Completed', 'Pending', 'Failed'][i % 3],
                          style: TextStyle(
                            fontFamily: ConstantString.fontFredoka,
                            color: getStatusColor(
                              ['Completed', 'Pending', 'Failed'][i % 3],
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 40,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.more_vert),
                    //     onPressed: () => _showTransactionOptions(context),
                    //   ),
                    // ),
                  ],
                ),
              ),

            // Pagination
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  void _showTransactionOptions(BuildContext context) {
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
}
