import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import '../models/course.dart';

class CourseFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<EnrollmentProvider>(context).courses;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Available Courses', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ...courses.map((course) => Card(
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.red[800]),
              title: Text('${course.code} - ${course.title}'),
              subtitle: Text(course.schedule),
              trailing: ElevatedButton(
                onPressed: () {
                  Provider.of<EnrollmentProvider>(context, listen: false)
                      .addCourse(course);
                },
                child: Text('Enroll'),
              ),
            ),
          )),
        ],
      ),
    );
  }
}