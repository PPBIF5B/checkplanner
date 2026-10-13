import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum Priority { rendah, sedang, tinggi }

extension PriorityX on Priority {
  String get label => switch (this) {
        Priority.rendah => 'Rendah',
        Priority.sedang => 'Sedang',
        Priority.tinggi => 'Tinggi',
      };

  Color get color => switch (this) {
        Priority.rendah => AppColors.blue,
        Priority.sedang => AppColors.orange,
        Priority.tinggi => AppColors.red,
      };
}

const List<String> kCategories = ['Pekerjaan', 'Belajar', 'Pribadi'];

const List<String> kReminders = [
  'Tanpa pengingat',
  'Tepat waktu',
  'Ingatkan 1 jam',
  'Ingatkan 1 hari',
];

class Task {
  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.due,
    this.reminder = 'Ingatkan 1 jam',
    this.priority = Priority.sedang,
    this.category = 'Pribadi',
    this.isDone = false,
  });

  final String id;
  String title;
  String description;
  DateTime due;
  String reminder;
  Priority priority;
  String category;
  bool isDone;
}
