import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/model/transaction_model.dart';
import 'package:vults/viewmodels/bloc/transaction/transaction_bloc.dart';
import 'package:vults/views/widgets/mobile/transaction_modal.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});
  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  String sortOrder = 'Date Ascending';

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactionsRequested());
  }

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
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is TransactionsLoaded) {
                return Column(
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
                          _buildTransactionList(context, state.transactions),
                          _buildTransactionList(
                            context,
                            state.transactions,
                            type: TransactionType.send,
                          ),
                          _buildTransactionList(
                            context,
                            state.transactions,
                            type: TransactionType.receive,
                          ),
                          _buildTransactionList(context, state.transactions),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is TransactionError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      fontFamily: ConstantString.fontFredoka,
                      color: ConstantString.white,
                      fontSize: 18,
                    ),
                  ),
                );
              }
              return Center(
                child: Text(
                  'No transactions found',
                  style: TextStyle(
                    fontFamily: ConstantString.fontFredoka,
                    color: ConstantString.white,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<Transaction> transactions, {
    TransactionType? type,
  }) {
    var filteredTransactions =
        type != null
            ? transactions.where((t) => t.type == type).toList()
            : transactions;

    if (sortOrder == 'Date Ascending') {
      filteredTransactions.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } else {
      filteredTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return GestureDetector(
          onTap: () => _showTransactionDetails(context, transaction),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
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
                      _getTransactionIcon(transaction.type),
                      color: Colors.black,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.type
                              .toString()
                              .split('.')
                              .last
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          transaction.formattedAmount,
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
                      'Ref No. ${transaction.id}',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                    Text(
                      transaction.formattedDate,
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

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.send:
        return Icons.arrow_upward;
      case TransactionType.receive:
        return Icons.arrow_downward;
    }
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    context.read<TransactionBloc>().add(
      LoadTransactionDetailsRequested(transaction.id),
    );
    showDialog(
      context: context,
      builder:
          (context) => BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionDetailsLoaded) {
                return TransactionModal(transaction: state.transaction);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
    );
  }
}
