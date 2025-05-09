import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vults/model/device_info_plus.dart';
import 'package:vults/model/user_model.dart' as model;
import 'package:vults/model/transaction_model.dart' as transaction_model;

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

      final QuerySnapshot transactionsSnapshot =
          await _firestore
              .collection('transactions')
              .where('userId', isEqualTo: user.uid)
              .orderBy('timestamp', descending: true)
              .get();

      return transactionsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return transaction_model.Transaction.fromJson({'id': doc.id, ...data});
      }).toList();
    } catch (e) {
      throw 'Empty transaction list.';
    }
  }
}
