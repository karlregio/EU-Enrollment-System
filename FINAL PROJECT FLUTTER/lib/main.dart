import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/enrollment_provider.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EnrollmentProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'University Enrollment',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<EnrollmentProvider>(
          builder: (context, provider, child) {
            return provider.student == null ? SignupScreen() : HomeScreen();
          },
        ),
      ),
    );
  }
}