enum AccountType { fixDeposit, savings, business, checking }

class AccountTransaction {
  final String fromAccount;
  final String toAccount;
  final AccountType accountType;
  final double amount;
  final String reference;

  AccountTransaction({
    required this.fromAccount,
    required this.toAccount,
    required this.accountType,
    required this.amount,
    required this.reference,
  });
}
