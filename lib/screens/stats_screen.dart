import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  // Data contoh untuk versi awal. Nantinya dihitung dari riwayat penyelesaian tugas.
  static const _weekly = [3, 5, 3, 6, 4, 7, 3];
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  Widget _summaryCard(BuildContext context, String value, String label,
      Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = TaskStore.instance;
    final maxVal = _weekly.reduce((a, b) => a > b ? a : b);

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final total = store.total;
        final perCategory = {
          for (final c in kCategories)
            c: store.tasks.where((t) => t.category == c).length,
        };
        final catColors = [AppColors.teal, AppColors.orange, AppColors.blue];

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Statistik',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text('Ringkasan produktivitas minggu ini',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _summaryCard(context, '86%',
                        'Selesai tepat waktu', AppColors.teal),
                    const SizedBox(width: 12),
                    _summaryCard(
                        context, '12', 'Hari beruntun', AppColors.orange),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tugas selesai per hari',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (var i = 0; i < _weekly.length; i++)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('${_weekly[i]}',
                                        style: const TextStyle(fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 100 * _weekly[i] / maxVal,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: _weekly[i] == maxVal
                                            ? AppColors.teal
                                            : AppColors.tealLight,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(_days[i],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Berdasarkan kategori',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      for (var i = 0; i < kCategories.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 80, child: Text(kCategories[i])),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: total == 0
                                        ? 0
                                        : perCategory[kCategories[i]]! / total,
                                    minHeight: 8,
                                    color: catColors[i],
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(total == 0
                                  ? '0%'
                                  : '${(perCategory[kCategories[i]]! / total * 100).round()}%'),
                            ],
                          ),
                        ),
                    ],
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
