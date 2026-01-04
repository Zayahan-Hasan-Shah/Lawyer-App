import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_bottom_navigation_provider/lawyer_bottom_navigation_provider.dart';
import 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/screens/lawyer_dashboard_screen.dart';
import 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/screens/lawyer_profile_screen.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_bottom_navbar.dart';

class LawyerBottomNavigationScreen extends ConsumerStatefulWidget {
  const LawyerBottomNavigationScreen({super.key});

  @override
  ConsumerState<LawyerBottomNavigationScreen> createState() =>
      _LawyerBottomNavigationScreenState();
}

class _LawyerBottomNavigationScreenState
    extends ConsumerState<LawyerBottomNavigationScreen> {
  final List<Widget> _screens = [
    LawyerDashboardScreen(),
    const Center(child: Text("Chat")),
    const Center(child: Text("Settings")),
    const LawyerProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(lawyerBottomNavigationProvider);

    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(lawyerBottomNavigationProvider.notifier).setIndex(index),
        items: [
          BottomNavItem(
            activeIcon: Icons.dashboard,
            inactiveIcon: Icons.dashboard_outlined,
            label: '',
          ),
          BottomNavItem(
            activeIcon: Icons.chat_bubble,
            inactiveIcon: Icons.chat_bubble_outline_outlined,
            label: '',
          ),
          BottomNavItem(
            activeIcon: Icons.settings,
            inactiveIcon: Icons.settings_outlined,
            label: '',
          ),
          BottomNavItem(
            activeIcon: Icons.person,
            inactiveIcon: Icons.person_outline,
            label: '',
          ),
        ],
      ),
    );
  }
}
