import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/course.dart';
import 'block_selection_screen.dart';

class CoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EnrollmentProvider>(context);
    final courses = provider.courses;
    final enrolledCourses = provider.enrolledCourses;
    final selectedBlock = provider.selectedBlock;
    final student = provider.student;
    final isOfficiallyEnrolled = student?.status == 'OFFICIALLY ENROLLED';

    // Only allow 2 blocks
    final allowedBlocks = ['Block A', 'Block B'];

    // Calculate totals for enrolled courses
    int enrolledTotalUnits = enrolledCourses.fold(0, (sum, c) => sum + c.units);
    int enrolledTotalHours = enrolledCourses.fold(0, (sum, c) => sum + c.hours);

    // Calculate totals for all available courses
    int availableTotalUnits = courses.fold(0, (sum, c) => sum + c.units);
    int availableTotalHours = courses.fold(0, (sum, c) => sum + c.hours);

    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects'),
        backgroundColor: Colors.red[800],
        automaticallyImplyLeading: false,
      ),
      body: selectedBlock == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please select a block to view subjects.', style: TextStyle(fontSize: 16)),
                ],
              ),
            )
          : Column(
              children: [
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  color: Colors.red[800],
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.menu_book, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        isOfficiallyEnrolled ? 'Registered Subjects' : 'Available Subjects',
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
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
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
                Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('Total Subjects', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('${courses.length}', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Total Units', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('$availableTotalUnits', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Total Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('$availableTotalHours', style: TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (enrolledCourses.isNotEmpty) ...[
                        Divider(),
                        SizedBox(height: 8),
                        Text('Enrolled Subjects Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Enrolled Subjects', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('${enrolledCourses.length}', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Enrolled Units', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('$enrolledTotalUnits', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Enrolled Hours', style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('$enrolledTotalHours', style: TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
} 