import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/date_utils.dart';

/// Penyimpanan tugas sementara (in-memory) untuk versi awal.
/// Pada tahap berikutnya diganti dengan Repository (SQLite + Firestore).
class TaskStore extends ChangeNotifier {
  TaskStore._() {
    _seed();
  }

  static final TaskStore instance = TaskStore._();

  final List<Task> _tasks = [];
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  int _counter = 0;

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get total => _tasks.length;
  int get doneCount => _tasks.where((t) => t.isDone).length;
  double get doneRatio => total == 0 ? 0 : doneCount / total;

  List<Task> tasksOn(DateTime day) {
    final list = _tasks.where((t) => isSameDay(t.due, day)).toList()
      ..sort((a, b) => a.due.compareTo(b.due));
    return list;
  }

  List<Task> get todayTasks => tasksOn(DateTime.now());

  String newId() => 't${_counter++}';

  void add(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void update(Task task) {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i != -1) {
      _tasks[i] = task;
      notifyListeners();
    }
  }

  void remove(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggle(Task task) {
    task.isDone = !task.isDone;
    notifyListeners();
  }

  void _seed() {
    final now = DateTime.now();
    DateTime at(int dayOffset, int h, int m) =>
        DateTime(now.year, now.month, now.day + dayOffset, h, m);

    _tasks.addAll([
      Task(
        id: newId(),
        title: 'Kirim laporan mingguan',
        description: 'Rangkum progres minggu ini dan lampirkan data pendukung.',
        due: at(0, 23, 59),
        priority: Priority.tinggi,
        category: 'Pekerjaan',
      ),
      Task(
        id: newId(),
        title: 'Rapat tim proyek',
        due: at(0, 15, 0),
        priority: Priority.sedang,
        category: 'Pekerjaan',
      ),
      Task(
        id: newId(),
        title: 'Belajar untuk ujian',
        due: at(0, 19, 30),
        priority: Priority.rendah,
        category: 'Belajar',
      ),
      Task(
        id: newId(),
        title: 'Beli kuota internet',
        due: at(0, 10, 0),
        priority: Priority.rendah,
        category: 'Pribadi',
        isDone: true,
      ),
      Task(
        id: newId(),
        title: 'Olahraga pagi',
        due: at(0, 6, 30),
        priority: Priority.rendah,
        category: 'Pribadi',
        isDone: true,
      ),
      Task(
        id: newId(),
        title: 'Balas email dosen',
        due: at(0, 8, 0),
        priority: Priority.sedang,
        category: 'Belajar',
        isDone: true,
      ),
      Task(
        id: newId(),
        title: 'Cetak bahan presentasi',
        due: at(0, 17, 0),
        priority: Priority.sedang,
        category: 'Pekerjaan',
      ),
      Task(
        id: newId(),
        title: 'Kerjakan tugas praktikum',
        due: at(1, 20, 0),
        priority: Priority.tinggi,
        category: 'Belajar',
      ),
      Task(
        id: newId(),
        title: 'Belanja kebutuhan dapur',
        due: at(2, 9, 0),
        priority: Priority.sedang,
        category: 'Pribadi',
      ),
      Task(
        id: newId(),
        title: 'Presentasi progres proyek',
        due: at(4, 13, 0),
        priority: Priority.tinggi,
        category: 'Pekerjaan',
      ),
    ]);
  }
}
