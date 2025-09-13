import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/exam_period.dart';
import '../models/transaction.dart';

class EnrollmentProvider with ChangeNotifier {
  Student? _student;
  String? _selectedBlock;
  List<Course> _courses = [];
  List<Course> _enrolledCourses = [];
  List<Transaction> _transactions = [];
  double _totalTuition = 50000.0;
  double _currentBalance = 50000.0;
  List<ExamPeriod> _examPeriods = [
    ExamPeriod(name: 'Prelim', billAmount: 8550.75, amountDue: 8550.75),
    ExamPeriod(name: 'Midterm', billAmount: 8550.75, amountDue: 8550.75),
    ExamPeriod(name: 'Semi-Finals', billAmount: 8550.75, amountDue: 8550.75),
    ExamPeriod(name: 'Finals', billAmount: 8550.75, amountDue: 8550.75),
  ];

  Student? get student => _student;
  String? get selectedBlock => _selectedBlock;
  List<Course> get courses => _courses;
  List<Course> get enrolledCourses => _enrolledCourses;
  List<ExamPeriod> get examPeriods => _examPeriods;
  List<Transaction> get transactions => _transactions;
  double get totalTuition => _totalTuition;
  double get currentBalance => _currentBalance;

  EnrollmentProvider() {
    _initializeCourses();
  }

  void _initializeCourses() {
    _courses = [
      Course(
        code: 'HUM102',
        title: 'Ethics',
        schedule: 'FRI - 3:00 PM - 6:00 PM\n(LR04)',
        units: 3,
        hours: 3,
        section: 'B190',
      ),
      Course(
        code: 'SCIE101',
        title: 'Science, Technology and Society',
        schedule: 'FRI - 10:00 AM - 1:00 PM\n(LR03)',
        units: 3,
        hours: 3,
        section: 'B189',
      ),
      Course(
        code: 'PE04A',
        title: 'Physical Activities Toward Health and Fitness 4 (Menu of Sports)',
        schedule: 'THU - 4:00 PM-6:00 PM\n(GYM1)',
        units: 2,
        hours: 2,
        section: 'J012',
      ),
      Course(
        code: 'CP104',
        title: 'Information Management',
        schedule: 'MW - 1:00 PM - 3:30 PM\n(CL-03)',
        units: 3,
        hours: 5,
        section: 'M048',
      ),
      Course(
        code: 'CP105',
        title: 'Applications Dev & Emerging Tech',
        schedule: 'TTH - 1:00 PM - 3:30 PM\n(CL-04)',
        units: 3,
        hours: 5,
        section: 'M049',
      ),
      Course(
        code: 'CSSP101',
        title: 'Social Issues and Professional Practice 1',
        schedule: 'TTH - 7:30 AM - 9:00 AM\n(CL-04)',
        units: 3,
        hours: 5,
        section: 'M050',
      ),
      Course(
        code: 'CSNET102',
        title: 'Networking 2 (Routing and Switching Essentials',
        schedule: 'TTH - 9:30 AM - 12:00 PM\n(CL-04)',
        units: 3,
        hours: 5,
        section: 'M050',
      )
    ];
  }

  void enrollStudent({
    required String name,
    required String course,
    required String term,
    required String credentials,
    required String password,
    required String studentType,
    required String major,
  }) {
    _student = Student(
      name: name,
      course: course,
      status: 'PENDING',
      term: term,
      credentials: credentials,
      password: password,
      studentType: studentType,
      major: major,
    );
    notifyListeners();
  }

  void setBlock(String block) {
    _selectedBlock = block;
    _initializeCoursesForBlock(block);
    notifyListeners();
  }

  void _initializeCoursesForBlock(String block) {
    if (block == 'Block A') {
      _courses = [
        Course(
          code: 'HUM102',
          title: 'Ethics',
          schedule: 'TTH 9:00 AM - 10:30 AM\n(LR04)',
          units: 3,
          hours: 3,
          section: 'B190',
        ),
        Course(
          code: 'SCIE101',
          title: 'Science, Technology and Society',
          schedule: 'TTH 7:30 AM - 9:00 AM \n(LR03)',
          units: 3,
          hours: 3,
          section: 'B189',
        ),
        Course(
          code: 'PE04A',
          title: 'Physical Activities Toward Health and Fitness 4 (Menu of Sports)',
          schedule: 'MON - 3:00 PM- 5:00 PM\n(GYM1)',
          units: 2,
          hours: 2,
          section: 'J012',
        ),
        Course(
          code: 'CP104',
          title: 'Information Management',
          schedule: 'TTH - 1:00 PM - 3:30 PM\n(CL-03)',
          units: 3,
          hours: 5,
          section: 'M048',
        ),
        Course(
          code: 'CP105',
          title: 'Applications Dev & Emerging Tech',
          schedule: 'TTH - 3:30 PM - 6:00 PM\n(CL-04)',
          units: 3,
          hours: 5,
          section: 'M049',
        ),
        Course(
          code: 'CSSP101',
          title: 'Social Issues and Professional Practice 1',
          schedule: 'MW - 1:00 PM - 2:30 PM\n(CL-04)',
          units: 3,
          hours: 5,
          section: 'M050',
        ),
        Course(
          code: 'CSNET102',
          title: 'Networking 2 (Routing and Switching Essentials',
          schedule: 'MW - 7:30 AM - 10:00 AM\n(CL-04)',
          units: 3,
          hours: 5,
          section: 'M050',
        ),
      ];
    } else {
      _initializeCourses(); // Block B or default
    }
  }

  void addCourse(Course course) {
    if (!_enrolledCourses.contains(course)) {
      _enrolledCourses.add(course);
      notifyListeners();
    }
  }

  void removeCourse(Course course) {
    _enrolledCourses.remove(course);
    notifyListeners();
  }

  bool isEnrolledInCourse(Course course) {
    return _enrolledCourses.contains(course);
  }

  bool isPaymentPending() {
    return _student != null && _student!.status == 'PENDING';
  }

  void payEnrollmentFee(double amount) {
    if (_student != null) {
      _student = Student(
        name: _student!.name,
        course: _student!.course,
        status: 'OFFICIALLY ENROLLED',
        term: _student!.term,
        credentials: _student!.credentials,
        password: _student!.password,
        studentType: _student!.studentType,
        major: _student!.major,
      );
      _currentBalance -= amount;
      if (_currentBalance < 0) _currentBalance = 0;
      double perPeriod = _currentBalance / 4;
      _examPeriods = [
        ExamPeriod(name: 'Prelim', billAmount: perPeriod, amountDue: perPeriod),
        ExamPeriod(name: 'Midterm', billAmount: perPeriod, amountDue: perPeriod),
        ExamPeriod(name: 'Semi-Finals', billAmount: perPeriod, amountDue: perPeriod),
        ExamPeriod(name: 'Finals', billAmount: perPeriod, amountDue: perPeriod),
      ];
      addTransaction(Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentName: _student!.name,
        amount: amount,
        date: DateTime.now(),
        status: 'completed',
        paymentMethod: 'Enrollment Fee',
        referenceNumber: 'ENROLL-${DateTime.now().millisecondsSinceEpoch}',
      ));
      notifyListeners();
    }
  }

  void payTuition(double amount) {
    _currentBalance -= amount;
    if (_currentBalance < 0) _currentBalance = 0;
    addTransaction(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentName: _student?.name ?? '',
      amount: amount,
      date: DateTime.now(),
      status: 'completed',
      paymentMethod: 'Tuition',
      referenceNumber: 'TUITION-${DateTime.now().millisecondsSinceEpoch}',
    ));
    notifyListeners();
  }

  void logout() {
    _student = null;
    _selectedBlock = null;
    _enrolledCourses.clear();
    _transactions.clear();
    _currentBalance = _totalTuition;
    notifyListeners();
  }

  List<Transaction> getAllTransactions() => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  double getPermitDue(String period) {
    final examPeriod = _examPeriods.firstWhere((p) => p.name == period);
    return examPeriod.amountDue;
  }

  void payExamPermit(String period, double amount) {
    final examPeriod = _examPeriods.firstWhere((p) => p.name == period);
    examPeriod.amountDue -= amount;
    if (examPeriod.amountDue <= 0) {
      examPeriod.isPermitValid = true;
    }
    _currentBalance -= amount;
    if (_currentBalance < 0) _currentBalance = 0;
    addTransaction(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentName: _student?.name ?? '',
      amount: amount,
      date: DateTime.now(),
      status: 'completed',
      paymentMethod: 'Exam Permit',
      referenceNumber: 'PERMIT-$period-${DateTime.now().millisecondsSinceEpoch}',
    ));
    notifyListeners();
  }
}