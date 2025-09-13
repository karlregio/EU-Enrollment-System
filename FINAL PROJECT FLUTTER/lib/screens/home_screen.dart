import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import 'courses_screen.dart';
import 'payment_screen.dart';
import 'profile_screen.dart';
import 'block_selection_screen.dart';
import 'exam_permit_payment_screen.dart';
import 'payment_history_screen.dart';
import '../models/exam_period.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    DashboardTab(),
    CoursesScreen(),
    ProfileScreen(),
  ];

  List<String> examPeriods = [
    'Prelim',
    'Midterm',
    'Semi-Finals',
    'Finals',
  ];
  String selectedPeriod = 'Prelim';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnrollmentProvider>(context);
    final student = provider.student;
    final isPaymentPending = provider.isPaymentPending();
    final isOfficiallyEnrolled = student?.status == 'OFFICIALLY ENROLLED';

    return Scaffold(
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    color: Colors.red[800],
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      'Registration Summary',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  if (provider.selectedBlock != null)
                    Card(
                      color: Colors.red[50],
                      margin: EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.group, color: Colors.red[800]),
                            SizedBox(width: 10),
                            Text(
                              isOfficiallyEnrolled ? 'Enrolled Block: ' : 'Block: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              provider.selectedBlock!,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!isOfficiallyEnrolled)
                    Column(
                      children: [
                        SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => BlockSelectionScreen(allowedBlocks: ['Block A', 'Block B'])),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text(provider.selectedBlock == null ? 'Select Block' : 'Change Block'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 8),
                  if (student != null)
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(student.course),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: student.status == "OFFICIALLY ENROLLED" 
                                    ? Colors.green 
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                student.status,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Total Tuition: ₱${provider.totalTuition.toStringAsFixed(2)}'),
                            Text('Current Balance: ₱${provider.currentBalance.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800])),
                            SizedBox(height: 16),
                            if (isPaymentPending)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (provider.selectedBlock == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Please select a block first.')),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => PaymentScreen()),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.payment),
                                  label: Text('Pay Enrollment Fee'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[800],
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: () {
                                final provider = Provider.of<EnrollmentProvider>(context, listen: false);
                                final student = provider.student;
                                if (student != null && student.status == 'OFFICIALLY ENROLLED') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Download Successfully')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please enroll first')),
                                  );
                                }
                              },
                              icon: Icon(Icons.download),
                              label: Text('Download Registration Form'),
                            ),
                            Divider(),
                            Text('Enrollment Term: ${student.term}'),
                            Text('Credentials: ${student.credentials}'),
                          ],
                        ),
                      ),
                    )
                  else
                    Text('No student enrolled yet.'),
                  SizedBox(height: 24),
                  if (isOfficiallyEnrolled) ...[
                    Text(
                      'Exam Permit Status',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.brown[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedPeriod,
                                  dropdownColor: Colors.brown[800],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  iconEnabledColor: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  items: examPeriods.map((String period) {
                                    return DropdownMenuItem<String>(
                                      value: period,
                                      child: Text(period),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedPeriod = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Builder(
                              builder: (context) {
                                final permitDue = provider.getPermitDue(selectedPeriod);
                                final isPaid = permitDue == 0;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bill Amount: Php ${permitDue.toStringAsFixed(2)}'),
                                    Text('Amount Due: Php ${permitDue.toStringAsFixed(2)}'),
                                    SizedBox(height: 8),
                                    Text(
                                      isPaid ? '✔ Valid Exam Permit' : '✖ Not Valid Exam Permit',
                                      style: TextStyle(
                                        color: isPaid ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (!isPaid)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => ExamPermitPaymentScreen(
                                                        period: provider.examPeriods.firstWhere((p) => p.name == selectedPeriod),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.receipt_long),
                                                label: Text('Pay Exam Permit'),
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PaymentHistoryScreen()),
                        );
                      },
                      icon: Icon(Icons.history, color: Colors.red[800]),
                      label: Text('History of Records', style: TextStyle(color: Colors.red[800])),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        side: BorderSide(color: Colors.red[800]!),
                      ),
                    ),
                  ],
                ],
              ),
            )
          : _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final student = Provider.of<EnrollmentProvider>(context).student;
    final isPaymentPending = Provider.of<EnrollmentProvider>(context).isPaymentPending();
    final selectedBlock = Provider.of<EnrollmentProvider>(context).selectedBlock;
    final tuition = Provider.of<EnrollmentProvider>(context).totalTuition;
    final balance = Provider.of<EnrollmentProvider>(context).currentBalance;
    final provider = Provider.of<EnrollmentProvider>(context);
    final isOfficiallyEnrolled = student?.status == 'OFFICIALLY ENROLLED';

    // Debug print to check student status
    print('DEBUG: student.status = \'${student?.status}\'');

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              color: Colors.red[800],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                'Registration Summary',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            if (selectedBlock != null)
              Card(
                color: Colors.red[50],
                margin: EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.group, color: Colors.red[800]),
                      SizedBox(width: 10),
                      Text(
                        isOfficiallyEnrolled ? 'Enrolled Block: ' : 'Block: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        selectedBlock,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800]),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isOfficiallyEnrolled)
              Column(
                children: [
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BlockSelectionScreen(allowedBlocks: ['Block A', 'Block B'])),
                      );
                    },
                    icon: Icon(Icons.edit),
                    label: Text(selectedBlock == null ? 'Select Block' : 'Change Block'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                    ),
                  ),
                ],
              ),
            SizedBox(height: 8),
            if (student != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(student.course),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: student.status == "OFFICIALLY ENROLLED" 
                              ? Colors.green 
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.status,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Total Tuition: ₱${tuition.toStringAsFixed(2)}'),
                      Text('Current Balance: ₱${balance.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800])),
                      SizedBox(height: 16),
                      if (isPaymentPending)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (provider.selectedBlock == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please select a block first.')),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => PaymentScreen()),
                                );
                              }
                            },
                            icon: Icon(Icons.payment),
                            label: Text('Pay Enrollment Fee'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[800],
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          final provider = Provider.of<EnrollmentProvider>(context, listen: false);
                          final student = provider.student;
                          if (student != null && student.status == 'OFFICIALLY ENROLLED') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Download Successfully')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enroll first')),
                            );
                          }
                        },
                        icon: Icon(Icons.download),
                        label: Text('Download Registration Form'),
                      ),
                      Divider(),
                      Text('Enrollment Term: ${student.term}'),
                      Text('Credentials: ${student.credentials}'),
                    ],
                  ),
                ),
              )
            else
              Text('No student enrolled yet.'),
            SizedBox(height: 24),
            if (isOfficiallyEnrolled) ...[
              Text(
                'Exam Permit Status',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              ...provider.examPeriods.map((period) {
                final permitDue = provider.getPermitDue(period.name);
                final isPaid = permitDue == 0;
                final firstUnpaid = provider.examPeriods.firstWhere((p) => p.amountDue > 0, orElse: () => provider.examPeriods.last);
                final isCurrentPayable = !isPaid && period == firstUnpaid;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.brown[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(period.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 8),
                            Text('Bill Amount: Php ${period.billAmount.toStringAsFixed(2)}'),
                            Text('Amount Due: Php ${permitDue.toStringAsFixed(2)}'),
                            SizedBox(height: 8),
                            Text(
                              isPaid ? '✔ Valid Exam Permit' : '✖ Not Valid Exam Permit',
                              style: TextStyle(
                                color: isPaid ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isCurrentPayable)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ExamPermitPaymentScreen(period: period),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.receipt_long),
                                        label: Text('Pay Exam Permit'),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}