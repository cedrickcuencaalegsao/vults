// Create a new file: lib/services/transaction_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vults/model/account_type.dart';
import 'package:vults/model/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper method to normalize account numbers
  String _normalizeAccountNumber(String accountNumber) {
    // Remove all dashes and spaces
    return accountNumber.replaceAll('-', '').replaceAll(' ', '').trim();
  }

  Future<void> processTransaction(AccountTransaction transaction) async {
    try {

      String accountType =
          transaction.accountType.toString().split('.').last.toLowerCase();
      if (accountType == 'fixdeposit') {
        accountType = 'fixed_deposit';
      }

      final normalizedInputAccount = _normalizeAccountNumber(
        transaction.toAccount,
      );

      final querySnapshot = await _firestore.collection('users').get();

      String? recipientUserId;
      for (var doc in querySnapshot.docs) {
        final userAccounts = List<Map<String, dynamic>>.from(
          doc.data()['userAccounts'] ?? [],
        );

        for (var account in userAccounts) {
          // Normalize the stored account number for comparison
          final storedAccount = _normalizeAccountNumber(
            account['account_id'].toString(),
          );

          if (storedAccount == normalizedInputAccount) {
            recipientUserId = doc.id;
            break;
          }
        }
        if (recipientUserId != null) break;
      }

      if (recipientUserId == null) {
        throw Exception('Invalid account number');
      }
      // Get sender and recipient references
      final senderRef = _firestore
          .collection('users')
          .doc(transaction.fromAccount);
      final recipientRef = _firestore.collection('users').doc(recipientUserId);

      // Start transaction batch
      final batch = _firestore.batch();

      // Update sender's balance
      final senderDoc = await senderRef.get();
      final senderAccounts = List<Map<String, dynamic>>.from(
        senderDoc.data()?['userAccounts'] ?? [],
      );

      bool senderUpdated = false;
      for (var i = 0; i < senderAccounts.length; i++) {
        if (senderAccounts[i].containsKey(accountType)) {
          double currentBalance = senderAccounts[i][accountType].toDouble();
          senderAccounts[i][accountType] = currentBalance - transaction.amount;
          senderUpdated = true;
          break;
        }
      }

      if (!senderUpdated) {
        throw Exception('Sender account type not found');
      }

      // Update recipient's balance
      final recipientDoc = await recipientRef.get();
      final recipientAccounts = List<Map<String, dynamic>>.from(
        recipientDoc.data()?['userAccounts'] ?? [],
      );

      bool recipientUpdated = false;
      for (var i = 0; i < recipientAccounts.length; i++) {
        if (recipientAccounts[i].containsKey(accountType)) {
          double currentBalance = recipientAccounts[i][accountType].toDouble();
          recipientAccounts[i][accountType] =
              currentBalance + transaction.amount;
          recipientUpdated = true;
          break;
        }
      }

      if (!recipientUpdated) {
        throw Exception('Recipient account type not found');
      }

      // Update both documents
      batch.update(senderRef, {'userAccounts': senderAccounts});
      batch.update(recipientRef, {'userAccounts': recipientAccounts});

      // We already have these documents from earlier fetches
      // Use the existing senderDoc and recipientDoc variables
      final senderName =
          '${senderDoc.data()?['firstName']} ${senderDoc.data()?['lastName']}';
      final recipientName =
          '${recipientDoc.data()?['firstName']} ${recipientDoc.data()?['lastName']}';

      // Create transaction record
      final transactionRecord = TransactionModel(
        fromAccount: senderName,
        toAccount: recipientName,
        fromAccountId: transaction.fromAccount,
        toAccountId: recipientUserId,
        amount: transaction.amount,
        accountType: accountType,
        reference: transaction.reference,
        timestamp: DateTime.now(),
        status: 'completed',
      );

      // Add transaction records to batch
      batch.set(
        _firestore.collection('transactions').doc(),
        transactionRecord.toMap(),
      );

      batch.set(
        _firestore
            .collection('users')
            .doc(transaction.fromAccount)
            .collection('transactions')
            .doc(),
        transactionRecord.toMap(),
      );

      batch.set(
        _firestore
            .collection('users')
            .doc(recipientUserId)
            .collection('transactions')
            .doc(),
        transactionRecord.toMap(),
      );

      // Commit all changes in one batch
      await batch.commit();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Add method to fetch user's transactions
  Stream<QuerySnapshot> getUserTransactions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Add method to fetch all transactions (for admin)
  Stream<QuerySnapshot> getAllTransactions() {
    return _firestore
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
