import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

enum TaskFilter { semua, hariIni, mendatang, selesai }

extension on TaskFilter {
  String get label => switch (this) {
        TaskFilter.semua => 'Semua',
        TaskFilter.hariIni => 'Hari Ini',
        TaskFilter.mendatang => 'Mendatang',
        TaskFilter.selesai => 'Selesai',
      };
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _store = TaskStore.instance;
  TaskFilter _filter = TaskFilter.semua;

  List<Task> _filtered() {
    final today = dateOnly(DateTime.now());
    final list = _store.tasks.where((t) {
      switch (_filter) {
        case TaskFilter.semua:
          return true;
        case TaskFilter.hariIni:
          return isSameDay(t.due, today);
        case TaskFilter.mendatang:
          return dateOnly(t.due).isAfter(today) && !t.isDone;
        case TaskFilter.selesai:
          return t.isDone;
      }
    }).toList()
      ..sort((a, b) => a.due.compareTo(b.due));
    return list;
  }

  void _openForm([Task? task]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final tasks = _filtered();
        final todayTasks = _store.todayTasks;
        final todayDone = todayTasks.where((t) => t.isDone).length;
        final todayRatio =
            todayTasks.isEmpty ? 0.0 : todayDone / todayTasks.length;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openForm(),
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Halo, Rina!',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${namaHari(now)}, ${now.day} ${namaBulan(now)} ${now.year}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: AppColors.tealLight,
                      child: Text('R',
                          style: TextStyle(
                              color: AppColors.teal,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Progres hari ini',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$todayDone dari ${todayTasks.length} tugas selesai',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            '${(todayRatio * 100).round()}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: todayRatio,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in TaskFilter.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f.label),
                            selected: _filter == f,
                            onSelected: (_) => setState(() => _filter = f),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (tasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text('Tidak ada tugas')),
                  )
                else
                  for (final t in tasks)
                    TaskTile(task: t, onTap: () => _openForm(t)),
              ],
            ),
          ),
        );
      },
    );
  }
}
