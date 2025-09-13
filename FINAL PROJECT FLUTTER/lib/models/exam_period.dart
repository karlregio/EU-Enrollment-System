class ExamPeriod {
  final String name; // e.g., 'Prelim'
  final double billAmount;
  double amountDue;
  bool isPermitValid;

  ExamPeriod({
    required this.name,
    required this.billAmount,
    required this.amountDue,
    this.isPermitValid = false,
  });
} 