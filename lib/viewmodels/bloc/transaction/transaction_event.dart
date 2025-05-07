part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactionsRequested extends TransactionEvent {}

class LoadTransactionDetailsRequested extends TransactionEvent {
  final String transactionId;

  const LoadTransactionDetailsRequested(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class CreateTransactionRequested extends TransactionEvent {
  final Map<String, dynamic> transactionData;

  const CreateTransactionRequested(this.transactionData);

  @override
  List<Object> get props => [transactionData];
}

class CancelTransactionRequested extends TransactionEvent {
  final String transactionId;

  const CancelTransactionRequested(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class ConfirmTransactionRequested extends TransactionEvent {
  final String transactionId;

  const ConfirmTransactionRequested(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}
