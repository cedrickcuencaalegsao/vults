import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/core/service/transaction_service.dart';
import 'package:vults/model/account_type.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';
import 'package:vults/views/widgets/mobile/error.dart';
import 'package:vults/views/widgets/mobile/success.dart';

class SendmoneyFirstScreen extends StatefulWidget {
  const SendmoneyFirstScreen({super.key});

  @override
  SendmoneyFirstScreenState createState() => SendmoneyFirstScreenState();
}

class SendmoneyFirstScreenState extends State<SendmoneyFirstScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  AccountType selectedAccountType = AccountType.savings;

  void _handleErrors(message) {
    ErrorSnackBar.show(
      context: context,
      message: message,
      backgroundColor: ConstantString.red,
    );
  }

  void _navigateTransaction(transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendmoneySecondScreen(transaction: transaction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Send Money',
        iconColor: Color(0xFF0A0043),
        fontColor: Color(0xFF0A0043),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ConstantString.lightBlue, ConstantString.darkBlue],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                20,
              ), // adds left, right, bottom padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Send Express logo and text
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.send_outlined,
                          color: ConstantString.white,
                          size: 75,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Send Express',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: ConstantString.fontFredokaOne,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Account number field
                  Text(
                    'Account number:',
                    style: TextStyle(
                      color: ConstantString.white,
                      fontSize: 18,
                      fontFamily: ConstantString.fontFredoka,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: ConstantString.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _accountController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        // Remove dashes and spaces before length check
                        String normalized = value
                            .replaceAll('-', '')
                            .replaceAll(' ', '');
                        if (normalized.length != 12) {
                          return 'Account number must be 12 digits';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(normalized)) {
                          return 'Account number must contain only digits';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter account number (e.g. XXXX-XXXX-XXXX)',
                      ),
                      style: TextStyle(
                        fontFamily: ConstantString.fontFredoka,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Amount field
                  Text(
                    'Amount:',
                    style: TextStyle(
                      color: ConstantString.white,
                      fontSize: 18,
                      fontFamily: ConstantString.fontFredoka,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: ConstantString.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Please enter a valid amount';
                        }
                        if (amount <= 0) {
                          return 'Amount must be greater than 0';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Enter amount',
                        prefixText: '₱', // Changed from $ to ₱
                      ),
                      style: TextStyle(
                        fontFamily: ConstantString.fontFredoka,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Send Money from section
                  Text(
                    'Send Money from:',
                    style: TextStyle(
                      color: ConstantString.white,
                      fontSize: 18,
                      fontFamily: ConstantString.fontFredoka,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Account option - Fix Deposit
                  _buildAccountOption(
                    "Fixed Deposit", // Changed from "Fix Deposit" to "Fixed Deposit"
                    AccountType.fixDeposit == selectedAccountType,
                    ConstantString.lightBlue,
                  ),
                  const SizedBox(height: 10),

                  // Account option - Savings
                  _buildAccountOption(
                    "Savings",
                    AccountType.savings == selectedAccountType,
                    ConstantString.green,
                  ),
                  const SizedBox(height: 10),

                  // Account option - Business
                  _buildAccountOption(
                    "Business",
                    AccountType.business == selectedAccountType,
                    ConstantString.orange,
                  ),
                  const SizedBox(height: 10),

                  // Account option - Checking
                  _buildAccountOption(
                    "Checking",
                    AccountType.checking == selectedAccountType,
                    ConstantString.darkBlue,
                  ),

                  const Spacer(),

                  // Continue button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(_amountController.text);

                          // Check sufficient balance
                          final hasSufficientBalance =
                              await _checkSufficientBalance(amount);
                          if (!hasSufficientBalance) {
                            _handleErrors(
                              'Insufficient balance in selected account',
                            );
                            return;
                          }

                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser == null) {
                            _handleErrors('Please login first');
                            return;
                          }

                          final transaction = AccountTransaction(
                            fromAccount:
                                currentUser.uid, // Using Firebase Auth user ID
                            toAccount: _accountController.text,
                            accountType: selectedAccountType,
                            amount: amount,
                            reference:
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                          );
                          _navigateTransaction(transaction);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) => SendmoneySecondScreen(
                          //           transaction: transaction,
                          //         ),
                          //   ),
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantString.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: ConstantString.darkBlue,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption(String title, bool isSelected, Color color) {
    final accountType = _getAccountTypeFromTitle(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccountType = accountType;
        });
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ConstantString.white,
                  fontSize: 18,
                  fontFamily: ConstantString.fontFredokaOne,
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ConstantString.white,
                  border: Border.all(color: ConstantString.white, width: 2),
                ),
                child:
                    isSelected
                        ? Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ConstantString.lightBlue,
                          ),
                        )
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AccountType _getAccountTypeFromTitle(String title) {
    switch (title.toLowerCase()) {
      case 'fixed deposit':
        return AccountType.fixDeposit;
      case 'savings':
        return AccountType.savings;
      case 'business':
        return AccountType.business;
      case 'checking':
        return AccountType.checking;
      default:
        return AccountType.savings;
    }
  }

  // Add this method to check if the account has sufficient balance
  Future<bool> _checkSufficientBalance(double amount) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      final userAccounts = List<Map<String, dynamic>>.from(
        userDoc.data()?['userAccounts'] ?? [],
      );

      // Convert selected account type to match Firestore field name
      String accountTypeString =
          selectedAccountType.toString().split('.').last.toLowerCase();
      if (accountTypeString == 'fixdeposit') {
        accountTypeString = 'fixed_deposit'; // Match the Firestore field name
      }

      // Find the specific account
      var accountBalance = 0.0;
      for (var account in userAccounts) {
        if (account.containsKey(accountTypeString)) {
          final balanceData = account[accountTypeString];
          if (balanceData != null) {
            if (balanceData is int) {
              accountBalance = balanceData.toDouble();
            } else if (balanceData is double) {
              accountBalance = balanceData;
            }
            break;
          }
        }
      }
      return accountBalance >= amount;
    } catch (e) {
      throw Exception('Failed to check balance: $e');
    }
  }
}

class SendmoneySecondScreen extends StatefulWidget {
  final AccountTransaction transaction;

  const SendmoneySecondScreen({required this.transaction, super.key});

  @override
  SendmoneySecondScreenState createState() => SendmoneySecondScreenState();
}

class SendmoneySecondScreenState extends State<SendmoneySecondScreen> {
  bool isConfirmed = false;
  final _transactionService = TransactionService();

  void _close() {
    Navigator.pop(context);
  }

  void _navigate(route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  void _success(message) {
    SuccessSnackBar.show(
      context: context,
      message: message,
      backgroundColor: ConstantString.green,
    );
  }

  void _error(message){
    ErrorSnackBar.show(
      context: context,
      message: message,
      backgroundColor: ConstantString.red,
    );
  }


  void _handleSendMoney() async {
    if (!isConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm the transaction')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await _transactionService.processTransaction(widget.transaction);

      // Hide loading indicator
      _close();

      // Show success and navigate back to dashboard
      _navigate('/dashboard');
      _success('Transaction successful.');
    } catch (e) {
      // Hide loading indicator
      _close();
      _error('Transaction failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Send Money',
        iconColor: Color(0xFF0A0043),
        fontColor: Color(0xFF0A0043),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ConstantString.lightBlue, ConstantString.darkBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Push content apart
              children: [
                // Middle text content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'You are sending',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '₱${widget.transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'to account: ${widget.transaction.toAccount}',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Account Type: ${widget.transaction.accountType.toString().split('.').last}',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Reference: ${widget.transaction.reference}',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 30,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'You can see this transaction on the',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 20,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'transaction tab',
                          style: TextStyle(
                            color: ConstantString.white,
                            fontSize: 20,
                            fontFamily: ConstantString.fontFredoka,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Section: Confirmation + Button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4.0,
                      ), // adds left margin
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isConfirmed,
                              onChanged: (value) {
                                setState(() {
                                  isConfirmed = value ?? false;
                                });
                              },
                              fillColor: WidgetStateProperty.all(
                                ConstantString.white,
                              ),
                              checkColor: ConstantString.lightBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'I confirm this transaction.',
                            style: TextStyle(
                              color: ConstantString.white,
                              fontSize: 16,
                              fontFamily: ConstantString.fontFredoka,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _handleSendMoney,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantString.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: ConstantString.darkBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: ConstantString.fontFredokaOne,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
