import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import 'signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<EnrollmentProvider>(context).student;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.red[800],
        ),
        body: Center(child: Text('No student enrolled')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.red[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<EnrollmentProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SignupScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.red[800]),
                      title: Text('Name'),
                      subtitle: Text(student.name),
                    ),
                    ListTile(
                      leading: Icon(Icons.school, color: Colors.red[800]),
                      title: Text('Course'),
                      subtitle: Text(student.course),
                    ),
                    ListTile(
                      leading: Icon(Icons.star, color: Colors.red[800]),
                      title: Text('Major'),
                      subtitle: Text(student.major),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.red[800]),
                      title: Text('Term'),
                      subtitle: Text("2024-2025"),
                    ),
                    ListTile(
                      leading: Icon(Icons.badge, color: Colors.red[800]),
                      title: Text('Credentials'),
                      subtitle: Text(student.credentials),
                    ),
                    ListTile(
                      leading: Icon(Icons.category, color: Colors.red[800]),
                      title: Text('Email Address'),
                      subtitle: Text(student.studentType),
                    ),
                    ListTile(
                      leading: Icon(Icons.lock, color: Colors.red[800]),
                      title: Text('Password'),
                      subtitle: Text(
                        _obscurePassword ? '••••••••' : student.password,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}