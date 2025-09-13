class Course {
  final String code;
  final String title;
  final String schedule;
  final int units;
  final int hours;
  final String section;

  Course({
    required this.code,
    required this.title,
    required this.schedule,
    required this.units,
    required this.hours,
    required this.section,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          title == other.title &&
          schedule == other.schedule &&
          units == other.units &&
          hours == other.hours &&
          section == other.section;

  @override
  int get hashCode =>
      code.hashCode ^
      title.hashCode ^
      schedule.hashCode ^
      units.hashCode ^
      hours.hashCode ^
      section.hashCode;
} 