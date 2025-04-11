import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/mobile/transaction_modal.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  String sortOrder = 'Date Ascending';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Transaction",
            style: TextStyle(
              color: ConstantString.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: ConstantString.fontFredokaOne,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.filter_list, color: Colors.white, size: 24),
              onSelected: (String value) {
                setState(() {
                  sortOrder = value;
                });
              },
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              offset: Offset(0, 40),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'Date Ascending',
                    height: 30,
                    child: Text(
                      'Date Ascending',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Date Descending',
                    height: 30,
                    child: Text(
                      'Date Descending',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ConstantString.lightBlue, ConstantString.darkBlue],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight + 16),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.transparent,
                  isScrollable: false,
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  tabs: [
                    Tab(text: "All"),
                    Tab(text: "Sent"),
                    Tab(text: "Received"),
                    Tab(text: "Transfer"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTransactionList(context),
                    _buildTransactionList(context, type: "Sent"),
                    _buildTransactionList(context, type: "Received"),
                    _buildTransactionList(context, type: "Transfer"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, {String? type}) {
    final transactions = [
      {
        "type": "Sent",
        "amount": "₱100.00",
        "ref": "Ref No. 123456789012345",
        "date": "April 4, 2025",
      },
      {
        "type": "Received",
        "amount": "₱100.00",
        "ref": "Ref No. 123456789012345",
        "date": "April 3, 2025",
      },
      {
        "type": "Transfer",
        "amount": "₱100.00",
        "ref": "Ref No. 123456789012345",
        "date": "April 3, 2025",
      },
      {
        "type": "Cash Out",
        "amount": "₱100.00",
        "ref": "Ref No. 123456789012345",
        "date": "April 2, 2025",
      },
      {
        "type": "Cash In",
        "amount": "₱100.00",
        "ref": "Ref No. 123456789012345",
        "date": "April 1, 2025",
      },
    ];
    final filteredTransactions =
        type == null
            ? transactions
            : transactions.where((t) => t["type"] == type).toList();
    if (sortOrder == 'Date Ascending') {
      filteredTransactions.sort((a, b) => a["date"]!.compareTo(b["date"]!));
    } else if (sortOrder == 'Date Descending') {
      filteredTransactions.sort((a, b) => b["date"]!.compareTo(a["date"]!));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return GestureDetector(
          onTap: () {
            _showTransactionDetails(context, transaction);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getTransactionIcon(transaction["type"]!),
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction["type"]!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          transaction["amount"]!,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      transaction["ref"]!,
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                    Text(
                      transaction["date"]!,
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case "Sent":
        return Icons.arrow_upward;
      case "Received":
        return Icons.arrow_downward;
      case "Transfer":
        return Icons.swap_horiz;
      case "Cash Out":
        return Icons.account_balance_wallet;
      case "Cash In":
        return Icons.attach_money;
      default:
        return Icons.monetization_on;
    }
  }

  void _showTransactionDetails(
    BuildContext context,
    Map<String, String> transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) => TransactionModal(transaction: transaction),
    );
  }
}
