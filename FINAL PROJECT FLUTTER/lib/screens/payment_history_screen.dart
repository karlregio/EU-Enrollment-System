import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/transaction.dart';

class PaymentHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<EnrollmentProvider>(context).getAllTransactions();
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
        backgroundColor: Colors.red[800],
      ),
      body: transactions.isEmpty
          ? Center(child: Text('No payment history.'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      tx.paymentMethod == 'Tuition' ? Icons.school : Icons.receipt_long,
                      color: Colors.red[800],
                    ),
                    title: Text('${tx.paymentMethod} Payment'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount: ₱${tx.amount.toStringAsFixed(2)}'),
                        Text('Date: ${tx.date.toLocal()}'),
                        Text('Reference: ${tx.referenceNumber}'),
                        Text('Status: ${tx.status}'),
                        Text('Method: ${tx.paymentMethod}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
} 