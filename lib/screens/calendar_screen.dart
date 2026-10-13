import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _store = TaskStore.instance;
  late DateTime _month;
  late DateTime _selected;

  static const _weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selected = dateOnly(now);
  }

  void _changeMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final offset = DateTime(_month.year, _month.month, 1).weekday - 1;
    final cellCount = offset + daysInMonth;

    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final dayTasks = _store.tasksOn(_selected);
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Kalender',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _changeMonth(-1),
                          ),
                          Text(
                            '${namaBulan(_month)} ${_month.year}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          for (final d in _weekdays)
                            Expanded(
                              child: Center(
                                child: Text(d,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cellCount,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, i) {
                          if (i < offset) return const SizedBox.shrink();
                          final day = DateTime(
                              _month.year, _month.month, i - offset + 1);
                          final count = _store.tasksOn(day).length;
                          final selected = isSameDay(day, _selected);
                          final isToday = isSameDay(day, DateTime.now());
                          return GestureDetector(
                            onTap: () => setState(() => _selected = day),
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.teal : null,
                                shape: BoxShape.circle,
                                border: (isToday && !selected)
                                    ? Border.all(color: AppColors.teal)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: selected ? Colors.white : null,
                                      fontWeight: selected || isToday
                                          ? FontWeight.bold
                                          : null,
                                    ),
                                  ),
                                  if (count > 0)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (var k = 0;
                                            k < (count > 3 ? 3 : count);
                                            k++)
                                          Container(
                                            width: 4,
                                            height: 4,
                                            margin: const EdgeInsets.only(
                                                top: 2, left: 1, right: 1),
                                            decoration: const BoxDecoration(
                                              color: AppColors.orange,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTanggal(_selected),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text('${dayTasks.length} tugas',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 10),
                if (dayTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('Tidak ada tugas pada tanggal ini')),
                  )
                else
                  for (final t in dayTasks)
                    TaskTile(
                      task: t,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => TaskFormScreen(task: t)),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
