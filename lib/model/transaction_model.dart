import 'package:intl/intl.dart';

enum TransactionType { send, receive }

enum TransactionStatus { pending, completed, failed }

class Transaction {
  final String id;
  final String senderId;
  final String receiverId;
  final double amount;
  final DateTime timestamp;
  final TransactionType type;
  final TransactionStatus status;
  final String? description;

  Transaction({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.timestamp,
    required this.type,
    required this.status,
    this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Handle different timestamp formats from Firestore
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return DateTime.now();
      if (timestamp is DateTime) return timestamp;
      if (timestamp is String) return DateTime.parse(timestamp);
      // Handle Firestore Timestamp
      if (timestamp.runtimeType.toString().contains('Timestamp')) {
        return timestamp.toDate();
      }
      return DateTime.now();
    }

    return Transaction(
      id: json['id'] as String,
      senderId: (json['senderId'] ?? json['fromAccountId'] ?? '') as String,
      receiverId: (json['receiverId'] ?? json['toAccountId'] ?? '') as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: parseTimestamp(json['timestamp']),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
        orElse:
            () =>
                json['fromAccountId'] != null
                    ? TransactionType.send
                    : TransactionType.receive,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString() == 'TransactionStatus.${json['status']}',
        orElse: () => TransactionStatus.completed,
      ),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'description': description,
    };
  }

  String get formattedAmount {
    final formatter = NumberFormat.currency(symbol: '₱');
    return formatter.format(amount);
  }

  String get formattedDate {
    final formatter = DateFormat('MMM d, y HH:mm');
    return formatter.format(timestamp);
  }

  Transaction copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    double? amount,
    DateTime? timestamp,
    TransactionType? type,
    TransactionStatus? status,
    String? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}

class TransactionModel {
  final String fromAccount;
  final String toAccount;
  final String fromAccountId;
  final String toAccountId;
  final double amount;
  final String accountType;
  final String reference;
  final DateTime timestamp;
  final String status;

  TransactionModel({
    required this.fromAccount,
    required this.toAccount,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.accountType,
    required this.reference,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromAccount': fromAccount,
      'toAccount': toAccount,
      'fromAccountId': fromAccountId,
      'toAccountId': toAccountId,
      'amount': amount,
      'accountType': accountType,
      'reference': reference,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
