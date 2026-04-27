import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'presentation/screens/about_screen.dart';
import 'presentation/screens/calendar_screen.dart';
import 'presentation/screens/cycle_calendar_screen.dart';
import 'presentation/screens/lunar_guide.dart';
import 'presentation/screens/moon_sighting_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return AppShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const CalendarScreen(),
            ),
            GoRoute(
              path: '/lunar_guide',
              builder: (context, state) => const LunarGuide(),
            ),
            GoRoute(
              path: '/planner',
              builder: (context, state) => const CycleCalendarScreen(),
            ),
            GoRoute(
              path: '/sightings',
              builder: (context, state) => const MoonSightingScreen(),
            ),
            GoRoute(
              path: '/about',
              builder: (context, state) => const AboutScreen(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shomer Zman',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  int _indexFromLocation(String location) {
    if (location.startsWith('/lunar_guide')) return 1;
    if (location.startsWith('/planner')) return 2;
    return 0;
  }

  String _locationFromIndex(int index) {
    switch (index) {
      case 1:
        return '/lunar_guide';
      case 2:
        return '/planner';
      default:
        return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      appBar: AppBar(title: const Text('Shomer Zman')),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              leading: const Icon(Icons.brightness_3),
              title: const Text('Sightings'),
              onTap: () {
                Navigator.pop(context);
                context.push('/sightings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                context.push('/about');
              },
            ),
          ],
        ),
      ),

      body: child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.go(_locationFromIndex(index)),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Planner',
          ),
        ],
      ),
    );
  }
}