part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionDetailsLoaded extends TransactionState {
  final Transaction transaction;

  const TransactionDetailsLoaded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionCreated extends TransactionState {
  final Transaction transaction;

  const TransactionCreated(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionCancelled extends TransactionState {
  final String transactionId;

  const TransactionCancelled(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class TransactionConfirmed extends TransactionState {
  final String transactionId;

  const TransactionConfirmed(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
