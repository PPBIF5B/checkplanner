import 'package:flutter/material.dart';

import 'data/task_store.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CheckPlannerApp());
}

class CheckPlannerApp extends StatelessWidget {
  const CheckPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: TaskStore.instance.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'CheckPlanner',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
