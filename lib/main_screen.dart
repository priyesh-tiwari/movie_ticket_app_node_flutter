import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_flutter_app/constants/app_constants.dart';
import 'package:movie_flutter_app/providers/auth_provider.dart';
import 'package:movie_flutter_app/screens/admin/admin_home_screen.dart';
import 'package:movie_flutter_app/screens/home/home_screen.dart';
import 'package:movie_flutter_app/screens/booking/my_booking_screen.dart';
import 'package:movie_flutter_app/screens/profile/profile_screen.dart';
import 'package:movie_flutter_app/widgets/drawer_widget.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final role    = ref.watch(authProvider).user?.role;
    final isAdmin = role == 'admin';

    final screens = [
      const HomeScreen(),
      const MyBookingScreen(),
      if (isAdmin) const AdminHomeScreen(),
      const ProfileScreen(),
    ];

    final safeIndex = _currentIndex.clamp(0, screens.length - 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: safeIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor:     AppColors.surface,
        selectedItemColor:   AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type:                BottomNavigationBarType.fixed,
        selectedFontSize:    AppFontSize.xs,
        unselectedFontSize:  AppFontSize.xs,
        selectedLabelStyle:  const TextStyle(fontWeight: FontWeight.bold),
        items: [
          const BottomNavigationBarItem(
            icon:       Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label:      'Home',
          ),
          const BottomNavigationBarItem(
            icon:       Icon(Icons.confirmation_number_outlined),
            activeIcon: Icon(Icons.confirmation_number),
            label:      'Bookings',
          ),
          if (isAdmin)
            const BottomNavigationBarItem(
              icon:       Icon(Icons.admin_panel_settings_outlined),
              activeIcon: Icon(Icons.admin_panel_settings),
              label:      'Admin',
            ),
          const BottomNavigationBarItem(
            icon:       Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label:      'Profile',
          ),
        ],
      ),
    );
  }
}