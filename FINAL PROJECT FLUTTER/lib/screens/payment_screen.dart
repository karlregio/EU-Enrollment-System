import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import 'payment_history_screen.dart';
import 'exam_permit_payment_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _amountController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnrollmentProvider>(context);
    final totalTuition = provider.totalTuition;
    final currentBalance = provider.currentBalance;
    final isFullyPaid = currentBalance == 0;
    final isOfficiallyEnrolled = (totalTuition - currentBalance) >= 10000;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Enrollment Fee'),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tuition Payment', style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16),
                    Text('Total Tuition: ₱${totalTuition.toStringAsFixed(2)}'),
                    Text('Current Balance: ₱${currentBalance.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800])),
                    SizedBox(height: 16),
                    if (!isFullyPaid) ...[
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter amount to pay (min ₱10,000)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : () => _processPayment(context, currentBalance),
                          child: Text('Pay'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                        ),
                      ),
                    ] else ...[
                      Center(
                        child: Text('You are now OFFICIALLY ENROLLED!',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double maxAmount) async {
    final provider = Provider.of<EnrollmentProvider>(context, listen: false);
    final input = _amountController.text.trim();
    final amount = double.tryParse(input) ?? 0;
    if (amount < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Minimum payment is ₱10,000')),
      );
      return;
    }
    if (amount > maxAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot pay more than your current balance')),
      );
      return;
    }
    String? paymentMethod;
    String? gcashNumber;
    await showDialog(
      context: context,
      builder: (context) {
        String? selectedMethod;
        final gcashController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Payment Method'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text('Gcash'),
                    value: 'Gcash',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() => selectedMethod = value);
                    },
                  ),
                  if (selectedMethod == 'Gcash')
                    TextField(
                      controller: gcashController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Gcash Number',
                        hintText: '09XXXXXXXXX',
                      ),
                      maxLength: 11,
                    ),
                  RadioListTile<String>(
                    title: Text('Cash'),
                    value: 'Cash',
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      setState(() => selectedMethod = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedMethod == null) return;
                    if (selectedMethod == 'Gcash') {
                      final num = gcashController.text.trim();
                      if (!RegExp(r'^\d{11}$').hasMatch(num)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Enter a valid 11-digit Philippine number (e.g. 09XXXXXXXXX)')),
                        );
                        return;
                      }
                      gcashNumber = '63' + num.substring(1);
                      paymentMethod = selectedMethod;
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
    if (paymentMethod == null) return;
    setState(() {
      _isProcessing = true;
    });
    await Future.delayed(Duration(seconds: 2));
    if (provider.student != null && provider.student!.status != 'OFFICIALLY ENROLLED') {
      provider.payEnrollmentFee(amount);
    } else {
      provider.payTuition(amount);
    }
    setState(() {
      _isProcessing = false;
      _amountController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful! Method: $paymentMethod${paymentMethod == 'Gcash' ? '\nGcash Number: $gcashNumber' : ''}')),
    );
  }
} 