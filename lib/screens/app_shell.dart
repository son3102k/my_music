import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/nav_item.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  void _onTab(int idx) {
    setState(() {
      _currentIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surface,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: Icons.home,
              label: 'Home',
              isActive: _currentIndex == 0,
              onTap: () => _onTab(0),
            ),
            NavItem(
              icon: Icons.search,
              label: 'Search',
              isActive: _currentIndex == 1,
              onTap: () => _onTab(1),
            ),
            NavItem(
              icon: Icons.library_music,
              label: 'Library',
              isActive: _currentIndex == 2,
              onTap: () => _onTab(2),
            ),
            NavItem(
              icon: Icons.person,
              label: 'Profile',
              isActive: _currentIndex == 3,
              onTap: () => _onTab(3),
            ),
          ],
        ),
      ),
    );
  }
}
