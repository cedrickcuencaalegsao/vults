import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vults/model/device_info_plus.dart';
import 'package:vults/model/user_model.dart' as model;
import 'package:vults/model/transaction_model.dart'
    as transaction_model; // Update this import

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user with email and PIN
  Future<model.User> register({
    required String email,
    required String firstName,
    String? middleName,
    required String lastName,
    required String birthday,
    required String pin,
  }) async {
    // Enable reCAPTCHA verification
    await _auth.setSettings(appVerificationDisabledForTesting: false);

    // Create authentication user
    final UserCredential userCredential = await _auth
        .createUserWithEmailAndPassword(email: email, password: pin);

    if (userCredential.user == null) {
      throw 'User creation failed - no user returned';
    }

    final String uid = userCredential.user!.uid;

    // Create user model
    final model.User newUser = model.User(
      id: uid,
      isAdmin: false,
      email: email,
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      birthday: DateTime.parse(birthday),
      pin: pin,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore.collection('users').doc(uid).set(newUser.toJson());
    } on FirebaseException catch (e) {
      throw 'Failed to save user data: ${e.message}';
    }

    return newUser;
  }

  // Add new method for device tracking
  Future<void> trackDevice(String userId) async {
    try {
      final deviceInfo = await PlatformService.getDeviceInfo();

      await _firestore.collection('devices').add({
        'userId': userId,
        'name': deviceInfo['name'],
        'type': deviceInfo['type'],
        'status': 'active',
        'lastActive': FieldValue.serverTimestamp(),
        'deviceInfo': deviceInfo['deviceInfo'],
      });
    } catch (e) {
      return Future.error('Failed to track device: $e');
    }
  }

  Future<model.User?> login({
    required String email,
    required String pin,
  }) async {
    try {
      // Sign in with email and PIN (used as password)
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: pin);

      final String uid = userCredential.user!.uid;
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        // Ensure the id is not null by adding it to userData
        userData['id'] = uid;

        final user = model.User.fromJson(userData);
        // Track device using the non-null uid
        await trackDevice(uid);
        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        throw 'Incorrect PIN.';
      }
      throw e.message ?? 'Login failed';
    } catch (e) {
      throw 'An error occurred during login';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<model.User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return model.User.fromJson(doc.data()!);
      }
    }
    return null;
  }

  Future<List<transaction_model.Transaction>> getUserTransactions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No authenticated user found';
      }

      // Get transactions where user is the sender
      final QuerySnapshot sentTransactionsSnapshot =
          await _firestore
              .collection('transactions')
              .where('fromAccountId', isEqualTo: user.uid)
              .get();

      // Get transactions where user is the receiver
      final QuerySnapshot receivedTransactionsSnapshot =
          await _firestore
              .collection('transactions')
              .where('toAccountId', isEqualTo: user.uid)
              .get();

      // Process sent transactions
      List<transaction_model.Transaction> sentTransactions =
          sentTransactionsSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return transaction_model.Transaction.fromJson({
              'id': doc.id,
              'senderId': data['fromAccountId'],
              'receiverId': data['toAccountId'],
              'amount': data['amount'],
              'timestamp': data['timestamp'],
              'type': 'send',
              'status': data['status'] ?? 'completed',
              'description': data['reference'],
            });
          }).toList();

      // Process received transactions
      List<transaction_model.Transaction> receivedTransactions =
          receivedTransactionsSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return transaction_model.Transaction.fromJson({
              'id': doc.id,
              'senderId': data['fromAccountId'],
              'receiverId': data['toAccountId'],
              'amount': data['amount'],
              'timestamp': data['timestamp'],
              'type': 'receive',
              'status': data['status'] ?? 'completed',
              'description': data['reference'],
            });
          }).toList();

      // Combine both lists
      List<transaction_model.Transaction> allTransactions = [
        ...sentTransactions,
        ...receivedTransactions,
      ];

      // Sort combined list by timestamp (newest first)
      allTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return allTransactions;
    } catch (e) {
      throw 'Failed to load transactions: $e';
    }
  }

  Future<List<transaction_model.Transaction>> getRecentTransactions() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No authenticated user found';
      }

      // Get transactions where user is the sender
      final QuerySnapshot sentTransactionsSnapshot =
          await _firestore
              .collection('transactions')
              .where('fromAccountId', isEqualTo: user.uid)
              .get();

      // Get transactions where user is the receiver
      final QuerySnapshot receivedTransactionsSnapshot =
          await _firestore
              .collection('transactions')
              .where('toAccountId', isEqualTo: user.uid)
              .get();

      // Process sent transactions
      List<transaction_model.Transaction> sentTransactions =
          sentTransactionsSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return transaction_model.Transaction.fromJson({
              'id': doc.id,
              'senderId': data['fromAccountId'],
              'receiverId': data['toAccountId'],
              'amount': data['amount'],
              'timestamp': data['timestamp'],
              'type': 'send',
              'status': data['status'] ?? 'completed',
              'description': data['reference'],
            });
          }).toList();

      // Process received transactions
      List<transaction_model.Transaction> receivedTransactions =
          receivedTransactionsSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return transaction_model.Transaction.fromJson({
              'id': doc.id,
              'senderId': data['fromAccountId'],
              'receiverId': data['toAccountId'],
              'amount': data['amount'],
              'timestamp': data['timestamp'],
              'type': 'receive',
              'status': data['status'] ?? 'completed',
              'description': data['reference'],
            });
          }).toList();

      // Combine both lists
      List<transaction_model.Transaction> allTransactions = [
        ...sentTransactions,
        ...receivedTransactions,
      ];

      // Sort combined list by timestamp (newest first)
      allTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return allTransactions;
    } catch (e) {
      throw 'Failed to load transactions: $e';
    }
  }

  Future<Map<String, double>> getCashInAndCashOut() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No authenticated user found';
      }

      // Get all transactions for the current month
      final DateTime now = DateTime.now();
      final DateTime startOfMonth = DateTime(now.year, now.month, 1);

      // Get cash in (received transactions)
      final QuerySnapshot cashInSnapshot =
          await _firestore
              .collection('transactions')
              .where('toAccountId', isEqualTo: user.uid)
              .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
              .get();

      // Get cash out (sent transactions)
      final QuerySnapshot cashOutSnapshot =
          await _firestore
              .collection('transactions')
              .where('fromAccountId', isEqualTo: user.uid)
              .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
              .get();

      double totalCashIn = 0;
      double totalCashOut = 0;

      // Calculate total cash in
      for (var doc in cashInSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalCashIn += (data['amount'] as num).toDouble();
      }

      // Calculate total cash out
      for (var doc in cashOutSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalCashOut += (data['amount'] as num).toDouble();
      }

      return {'cashIn': totalCashIn, 'cashOut': totalCashOut};
    } catch (e) {
      throw 'Failed to calculate cash flow: $e';
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'No authenticated user found';
      }

      final QuerySnapshot sentTransactions =
          await _firestore
              .collection('transactions')
              .where('fromAccountId', isEqualTo: user.uid)
              .get();

      final QuerySnapshot receivedTransactions =
          await _firestore
              .collection('transactions')
              .where('toAccountId', isEqualTo: user.uid)
              .get();

      double totalSentAmount = 0;
      double totalReceivedAmount = 0;
      Map<String, int> transactionsByType = {
        'checking': 0,
        'savings': 0,
        'business': 0,
      };

      // Add status tracking
      Map<String, int> transactionsByStatus = {
        'completed': 0,
        'pending': 0,
        'failed': 0,
      };

      // Process sent transactions
      for (var doc in sentTransactions.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalSentAmount += (data['amount'] as num).toDouble();
        String type = data['accountType'] as String;
        String status = (data['status'] as String?) ?? 'completed';

        transactionsByType[type] = (transactionsByType[type] ?? 0) + 1;
        transactionsByStatus[status] = (transactionsByStatus[status] ?? 0) + 1;
      }

      // Process received transactions
      for (var doc in receivedTransactions.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalReceivedAmount += (data['amount'] as num).toDouble();
        String status = (data['status'] as String?) ?? 'completed';
        transactionsByStatus[status] = (transactionsByStatus[status] ?? 0) + 1;
      }

      // Calculate totals
      int totalTransactions = sentTransactions.size + receivedTransactions.size;
      double totalAmount = totalSentAmount + totalReceivedAmount;

      return {
        'totalTransactions': totalTransactions,
        'totalAmount': totalAmount,
        'averageAmount':
            totalTransactions > 0 ? totalAmount / totalTransactions : 0,
        'transactionsByType': transactionsByType,
        'sentAmount': totalSentAmount,
        'receivedAmount': totalReceivedAmount,
        'transactionStats': {
          'checking': transactionsByType['checking'] ?? 0,
          'savings': transactionsByType['savings'] ?? 0,
          'business': transactionsByType['business'] ?? 0,
        },
        'transactionsByStatus': {
          'completed': transactionsByStatus['completed'] ?? 0,
          'pending': transactionsByStatus['pending'] ?? 0,
          'failed': transactionsByStatus['failed'] ?? 0,
        },
      };
    } catch (e) {
      throw 'Failed to generate statistics: $e';
    }
  }
}
