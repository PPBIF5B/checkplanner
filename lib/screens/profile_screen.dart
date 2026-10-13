import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../theme/app_theme.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _stat(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teal)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _menu(IconData icon, String title) => ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.tealLight,
          child: Icon(icon, size: 16, color: AppColors.teal),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      );

  @override
  Widget build(BuildContext context) {
    final store = TaskStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Profil',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.tealLight,
                    child: Text('R',
                        style: TextStyle(
                            fontSize: 28,
                            color: AppColors.teal,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text('Rina Amelia',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: Text('rina.amelia@email.com',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _stat(context, '${store.doneCount}', 'Selesai'),
                    const SizedBox(width: 10),
                    _stat(context, '${store.total - store.doneCount}', 'Aktif'),
                    const SizedBox(width: 10),
                    _stat(context, '12', 'Hari beruntun'),
                  ],
                ),
                const SizedBox(height: 12),
                _menu(Icons.edit_outlined, 'Edit Profil'),
                _menu(Icons.notifications_outlined, 'Pengingat & Notifikasi'),
                _menu(Icons.label_outline, 'Kategori Saya'),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: store.themeMode,
                  builder: (context, mode, _) => SwitchListTile(
                    secondary: const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.tealLight,
                      child: Icon(Icons.dark_mode_outlined,
                          size: 16, color: AppColors.teal),
                    ),
                    title: const Text('Tampilan Gelap'),
                    value: mode == ThemeMode.dark,
                    onChanged: (v) => store.themeMode.value =
                        v ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
                _menu(Icons.help_outline, 'Bantuan'),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: AppColors.red),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (_) => false,
                  ),
                  child: const Text('Keluar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
