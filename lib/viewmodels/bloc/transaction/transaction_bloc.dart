import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vults/model/transaction_model.dart';
import 'package:vults/core/service/service.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AuthService _authService = AuthService();

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
      final transactions = await _authService.getUserTransactions(); // <-- use Firestore
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
      final transactions = await _authService.getUserTransactions();
      final transaction = transactions.firstWhere(
        (tx) => tx.id == event.transactionId,
        orElse: () => throw 'Transaction not found',
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
      // Simulate creation (extend here to call Firestore if needed)
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
      await Future.delayed(const Duration(milliseconds: 500));
      emit(TransactionConfirmed(event.transactionId));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
