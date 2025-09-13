import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/course.dart';

class RegisterSubjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enrolledCourses = Provider.of<EnrollmentProvider>(context).enrolledCourses;

    int totalUnits = enrolledCourses.fold(0, (sum, c) => sum + c.units);
    int totalHours = enrolledCourses.fold(0, (sum, c) => sum + c.hours);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Subjects'),
        backgroundColor: Colors.black87,
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.menu_book, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Registered Subjects',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text('Section', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 5, child: Text('Subject/\nSchedule (Day(s) - Time (Room))', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Units', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Hrs.', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: enrolledCourses.isEmpty
                ? Center(child: Text('No registered subjects.'))
                : ListView.builder(
              itemCount: enrolledCourses.length,
              itemBuilder: (context, index) {
                final course = enrolledCourses[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(course.section)),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${course.code}: ${course.title}', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(course.schedule, style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(child: Text('${course.units}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${course.hours}', textAlign: TextAlign.center)),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Total Subjects', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('${enrolledCourses.length}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Total Units', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('$totalUnits', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Payable Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('$totalHours', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}