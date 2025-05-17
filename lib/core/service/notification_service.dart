import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Notification service to handle Firebase push notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    print('Initializing NotificationService...');
    try {
      // Set up Firebase Messaging
      print('Setting up Firebase Messaging...');
      try {
        await Firebase.initializeApp();
        print('Firebase initialized successfully');
      } catch (e) {
        print('Firebase may already be initialized: $e');
        // Continue as Firebase might be initialized in main.dart
      }
      
      // Request permission for iOS
      print('Requesting notification permissions...');
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('Notification permission status: ${settings.authorizationStatus}');
      
      // Configure local notifications
      print('Configuring local notifications...');
      try {
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        final DarwinInitializationSettings initializationSettingsIOS =
            DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
        final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
        await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
        );
        print('Local notifications configured successfully');
      } catch (e) {
        print('Error configuring local notifications: $e');
        // Continue as we can still try to use other notification methods
      }

      // Handle background messages
      print('Setting up Firebase message handlers...');
      try {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        
        // Handle messages when app is in foreground
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Received foreground message: ${message.notification?.title}');
          _showLocalNotificationFromMessage(message);
        });
        
        // Get FCM token
        print('Getting FCM token...');
        String? token = await _firebaseMessaging.getToken();
        print('FCM token: ${token ?? 'null'}');
        if (token != null) {
          try {
            await _updateUserFcmToken(token);
            print('FCM token updated successfully');
          } catch (e) {
            print('Error updating FCM token: $e');
            // Continue as this is not critical for basic notifications
          }
        }
        
        // Listen for token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          print('FCM token refreshed');
          _updateUserFcmToken(newToken);
        });
        
        print('Firebase message handlers set up successfully');
      } catch (e) {
        print('Error setting up Firebase message handlers: $e');
        // Continue as we can still use local notifications
      }
      
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
      // Don't rethrow the exception to prevent app crash
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  static Future<void> _showLocalNotificationFromMessage(RemoteMessage message) async {
    print('Showing local notification from RemoteMessage');
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        print('Notification details: title=${notification.title}, body=${notification.body}');
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'transaction_channel',
              'Transaction Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
        print('Local notification shown successfully');
      } else {
        print('Invalid notification data in RemoteMessage');
      }
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  static Future<void> _updateUserFcmToken(String token) async {
    // Store FCM token in Firestore
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'fcmToken': token});
        print('FCM token updated in Firestore');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }
  
  // Send a transaction notification via Firebase
  static Future<void> sendTransactionNotification({
    required String receiverId,
    required String senderName,
    required double amount,
    required String transactionId,
  }) async {
    try {
      print('Sending transaction notification for transaction: $transactionId');
      
      // Get receiver's FCM token from Firestore
      final receiverDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();
      
      final String? receiverToken = receiverDoc.data()?['fcmToken'];
      
      if (receiverToken != null && receiverToken.isNotEmpty) {
        // In a real app, you would send this to your Firebase Cloud Functions
        // or a backend service that can send FCM messages
        print('Receiver has FCM token: $receiverToken');
        print('In a production app, this would trigger a Firebase Cloud Function to send the notification');
        
        // For now, we'll just show a local notification as a demonstration
        await showTransactionNotification(
          title: 'New Transaction',
          body: 'You received $amount from $senderName',
          payload: transactionId,
        );
      } else {
        print('Receiver does not have an FCM token, cannot send push notification');
      }
    } catch (e) {
      print('Error sending transaction notification: $e');
    }
  }
  
  // Show a transaction notification
  static Future<void> showTransactionNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('Showing transaction notification: $title - $body');
    try {
      const androidDetails = AndroidNotificationDetails(
        'transaction_channel',
        'Transaction Notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      
      print('Transaction notification shown successfully');
    } catch (e) {
      print('Error showing transaction notification: $e');
    }
  }
}
