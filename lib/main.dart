import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'theme/theme_notifier.dart';
import 'providers/playback_notifier.dart';
import 'providers/volume_notifier.dart';
import 'screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try to warm up path_provider; on some platforms/plugins (e.g. during
  // unit/widget tests) the plugin may not be available, which throws
  // a MissingPluginException. We can safely ignore that.
  try {
    await getTemporaryDirectory();
  } catch (e) {
    // ignore: avoid_print
    print('path_provider initialization skipped: $e');
  }

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
        ChangeNotifierProvider(create: (_) => VolumeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return AnimatedTheme(
            data: themeNotifier.themeData,
            duration: const Duration(milliseconds: 500),
            child: MaterialApp(
              title: 'My Music',
              theme: themeNotifier.themeData,
              home: const AppInitializer(),
            ),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        final playback = context.read<PlaybackNotifier>();
        await playback.initialize();
      }
    } catch (e) {
      print('Error initializing app: $e');
      // Continue anyway - the app can function with sample data
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        // Show AppShell even if there's an error or still loading
        // The app can work with sample data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading library...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        }
        return const AppShell();
      },
    );
  }
}

