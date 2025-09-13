import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/enrollment_provider.dart';
import 'home_screen.dart';

class BlockSelectionScreen extends StatelessWidget {
  final List<String> allowedBlocks;
  const BlockSelectionScreen({Key? key, required this.allowedBlocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Block'), backgroundColor: Colors.red[800]),
      body: ListView.builder(
        padding: EdgeInsets.all(24),
        itemCount: allowedBlocks.length,
        itemBuilder: (context, index) {
          final block = allowedBlocks[index];
          final provider = Provider.of<EnrollmentProvider>(context, listen: false);
          
          // Temporarily set the block to calculate totals
          provider.setBlock(block);
          final courses = provider.courses;
          final totalSubjects = courses.length;
          final totalUnits = courses.fold(0, (sum, course) => sum + course.units);
          final totalHours = courses.fold(0, (sum, course) => sum + course.hours);
          
          return Card(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: ListTile(
              title: Text(block, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              onTap: () {
                provider.setBlock(block);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
} 