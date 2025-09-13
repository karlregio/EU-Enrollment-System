class Transaction {
  final String id;
  final String studentName;
  final double amount;
  final DateTime date;
  final String status; // 'pending', 'completed', 'failed'
  final String paymentMethod;
  final String referenceNumber;

  Transaction({
    required this.id,
    required this.studentName,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.referenceNumber,
  });
} 