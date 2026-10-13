import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';

/// Layar Tambah Tugas (task == null) sekaligus Edit Tugas (task != null).
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});

  final Task? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late DateTime _date;
  late TimeOfDay _time;
  late String _reminder;
  late Priority _priority;
  late String _category;

  bool get _isEdit => widget.task != null;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = TextEditingController(text: t?.title ?? '');
    _desc = TextEditingController(text: t?.description ?? '');
    final due = t?.due ?? DateTime.now().add(const Duration(days: 1));
    _date = dateOnly(due);
    _time = t != null
        ? TimeOfDay(hour: due.hour, minute: due.minute)
        : const TimeOfDay(hour: 23, minute: 59);
    _reminder = t?.reminder ?? kReminders[2];
    _priority = t?.priority ?? Priority.sedang;
    _category = t?.category ?? kCategories.first;
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final due = DateTime(
        _date.year, _date.month, _date.day, _time.hour, _time.minute);
    final store = TaskStore.instance;
    if (_isEdit) {
      final t = widget.task!
        ..title = _title.text.trim()
        ..description = _desc.text.trim()
        ..due = due
        ..reminder = _reminder
        ..priority = _priority
        ..category = _category;
      store.update(t);
    } else {
      store.add(Task(
        id: store.newId(),
        title: _title.text.trim(),
        description: _desc.text.trim(),
        due: due,
        reminder: _reminder,
        priority: _priority,
        category: _category,
      ));
    }
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_outline, color: AppColors.red, size: 32),
        title: const Text('Hapus tugas ini?'),
        content: Text('Tugas "${widget.task!.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red,
              minimumSize: const Size(88, 40),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      TaskStore.instance.remove(widget.task!.id);
      Navigator.of(context).pop();
    }
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        title: Text(_isEdit ? 'Edit Tugas' : 'Tugas Baru'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              _label('Judul Tugas'),
              TextFormField(
                controller: _title,
                decoration:
                    const InputDecoration(hintText: 'Contoh: Kerjakan laporan'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Judul tugas wajib diisi'
                    : null,
              ),
              _label('Deskripsi'),
              TextFormField(
                controller: _desc,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: 'Tambahkan catatan (opsional)'),
              ),
              _label('Tenggat'),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.calendar_today, size: 18)),
                  child: Text(formatTanggal(_date)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.access_time, size: 18)),
                        child: Text(
                            '${_time.hour.toString().padLeft(2, '0')}.${_time.minute.toString().padLeft(2, '0')}'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _reminder,
                      isExpanded: true,
                      items: [
                        for (final r in kReminders)
                          DropdownMenuItem(value: r, child: Text(r)),
                      ],
                      onChanged: (v) => setState(() => _reminder = v!),
                    ),
                  ),
                ],
              ),
              _label('Prioritas'),
              Row(
                children: [
                  for (final p in Priority.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(Icons.circle, size: 10, color: p.color),
                        label: Text(p.label),
                        selected: _priority == p,
                        onSelected: (_) => setState(() => _priority = p),
                      ),
                    ),
                ],
              ),
              _label('Kategori'),
              Wrap(
                spacing: 8,
                children: [
                  for (final c in kCategories)
                    ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _save,
                child: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan Tugas'),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: AppColors.red),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _confirmDelete,
                  child: const Text('Hapus Tugas'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
