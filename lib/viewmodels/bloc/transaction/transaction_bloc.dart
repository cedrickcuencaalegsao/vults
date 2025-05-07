import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/transaction_model.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactionsRequested>(_onLoadTransactionsRequested);
    on<LoadTransactionDetailsRequested>(_onLoadTransactionDetailsRequested);
    on<CreateTransactionRequested>(_onCreateTransactionRequested);
    on<CancelTransactionRequested>(_onCancelTransactionRequested);
    on<ConfirmTransactionRequested>(_onConfirmTransactionRequested);
  }

  Future<void> _onLoadTransactionsRequested(
    LoadTransactionsRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      // Here you would typically call your transaction service
      // For now, we'll simulate loading transactions
      await Future.delayed(const Duration(seconds: 1));
      final transactions = [
        Transaction(
          id: '1',
          senderId: 'user1',
          receiverId: 'user2',
          amount: 100.0,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: TransactionType.send,
          status: TransactionStatus.completed,
          description: 'Payment for services',
        ),
        Transaction(
          id: '2',
          senderId: 'user3',
          receiverId: 'user1',
          amount: 50.0,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          type: TransactionType.receive,
          status: TransactionStatus.pending,
          description: 'Refund',
        ),
      ];
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onLoadTransactionDetailsRequested(
    LoadTransactionDetailsRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      // Here you would typically call your transaction service
      // For now, we'll simulate loading transaction details
      await Future.delayed(const Duration(milliseconds: 500));
      final transaction = Transaction(
        id: event.transactionId,
        senderId: 'user1',
        receiverId: 'user2',
        amount: 100.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.send,
        status: TransactionStatus.completed,
        description: 'Payment for services',
      );
      emit(TransactionDetailsLoaded(transaction));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onCreateTransactionRequested(
    CreateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      // Here you would typically call your transaction service
      // For now, we'll simulate creating a transaction
      await Future.delayed(const Duration(milliseconds: 500));
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: event.transactionData['senderId'] as String,
        receiverId: event.transactionData['receiverId'] as String,
        amount: event.transactionData['amount'] as double,
        timestamp: DateTime.now(),
        type: TransactionType.values.firstWhere(
          (e) =>
              e.toString() ==
              'TransactionType.${event.transactionData['type']}',
        ),
        status: TransactionStatus.pending,
        description: event.transactionData['description'] as String?,
      );
      emit(TransactionCreated(transaction));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onCancelTransactionRequested(
    CancelTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      // Here you would typically call your transaction service
      // For now, we'll simulate cancelling a transaction
      await Future.delayed(const Duration(milliseconds: 500));
      emit(TransactionCancelled(event.transactionId));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onConfirmTransactionRequested(
    ConfirmTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      // Here you would typically call your transaction service
      // For now, we'll simulate confirming a transaction
      await Future.delayed(const Duration(milliseconds: 500));
      emit(TransactionConfirmed(event.transactionId));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
