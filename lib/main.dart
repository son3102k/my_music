import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/theme_notifier.dart';
import 'providers/playback_notifier.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => PlaybackNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return AnimatedTheme(
          data: themeNotifier.themeData,
          duration: const Duration(milliseconds: 500),
          child: MaterialApp(
            title: 'My Music',
            theme: themeNotifier.themeData,
            home: const AppShell(),
          ),
        );
        },
      ),
    );
  }
}

