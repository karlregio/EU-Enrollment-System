import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/exam_period.dart';

class ExamPermitPaymentScreen extends StatelessWidget {
  final ExamPeriod period;

  const ExamPermitPaymentScreen({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pay ${period.name} Exam Permit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exam Permit Details',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text('Period: ${period.name}'),
                      Text('Amount Due: ₱${period.amountDue.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  if (amount > period.amountDue) {
                    return 'Amount cannot exceed the due amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
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
                                        hintText: '9123456789',
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
                                      if (!RegExp(r'^\d{10}\u0000').hasMatch(num)) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Enter a valid 10-digit Philippine number (e.g. 9123456789)')),
                                        );
                                        return;
                                      }
                                      if (num.startsWith('0')) {
                                        gcashNumber = '63' + num.substring(1);
                                      } else {
                                        gcashNumber = '63' + num;
                                      }
                                    }
                                    paymentMethod = selectedMethod;
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
                    final amount = double.parse(amountController.text);
                    Provider.of<EnrollmentProvider>(context, listen: false)
                        .payExamPermit(period.name, amount);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment successful! Method: $paymentMethod${paymentMethod == 'Gcash' ? '\nGcash Number: $gcashNumber' : ''}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Pay Exam Permit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 