import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/course.dart';

class RegistrationSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final student = Provider.of<EnrollmentProvider>(context).student;
    final enrolledCourses = Provider.of<EnrollmentProvider>(context).enrolledCourses;

    int totalUnits = enrolledCourses.fold(0, (sum, c) => sum + c.units);
    int totalHours = enrolledCourses.fold(0, (sum, c) => sum + c.hours);

    return Scaffold(
      appBar: AppBar(title: Text('Registration Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (student != null) ...[
              Text(student.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(student.course),
              Text('Status: ${student.status}', style: TextStyle(color: Colors.green)),
              SizedBox(height: 8),
              Text('Enrollment Term: ${student.term}'),
              Text('Credentials: ${student.credentials}'),
              if (student.status == "OFFICIALLY ENROLLED")
                Text('✅ Officially Enrolled', style: TextStyle(color: Colors.green)),
              SizedBox(height: 16),
            ],
            Text('Registered Subjects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            DataTable(
              columns: [
                DataColumn(label: Text('Section')),
                DataColumn(label: Text('Subject/Schedule')),
                DataColumn(label: Text('Units')),
                DataColumn(label: Text('Hrs.')),
              ],
              rows: enrolledCourses.map((course) => DataRow(cells: [
                DataCell(Text(course.section)),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${course.code}: ${course.title}'),
                    Text(course.schedule, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )),
                DataCell(Text('${course.units}')),
                DataCell(Text('${course.hours}')),
              ])).toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Total Subjects: ${enrolledCourses.length}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Total Units: $totalUnits', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Payable Hours: $totalHours', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Download not implemented')),
                );
              },
              child: Text('Download Registration Form'),
            ),
          ],
        ),
      ),
    );
  }
}