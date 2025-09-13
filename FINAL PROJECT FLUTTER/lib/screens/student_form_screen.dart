import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/enrollment_provider.dart';
import '../screens/block_selection_screen.dart';

class StudentFormScreen extends StatefulWidget {
  @override
  _StudentFormScreenState createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  Course? _selectedCourse;
  bool _obscurePassword = true;

  final List<String> _studentTypes = ['New Enrollee', 'Irregular'];

  @override
  Widget build(BuildContext context) {
    final courses = Provider.of<EnrollmentProvider>(context).courses;

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), backgroundColor: Colors.red[800]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: 'BSIT'),
              decoration: InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              maxLength: 14,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password (max 14 characters)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
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
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _passwordController.text.length <= 14 &&
                    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{1,14}$').hasMatch(_passwordController.text)) {
                  Provider.of<EnrollmentProvider>(context, listen: false)
                      .enrollStudent(
                    name: _nameController.text,
                    course: 'BSIT',
                    term: '2023-2024',
                    credentials: 'Student ID - A24-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6)}',
                    password: _passwordController.text,
                    studentType: _emailController.text,
                    major: 'Web and Mobile',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BlockSelectionScreen(allowedBlocks: ['Block A', 'Block B'])),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red[800],
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}