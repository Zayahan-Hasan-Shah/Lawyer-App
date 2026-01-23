import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_bottom_navigation_provider/lawyer_bottom_navigation_provider.dart';
import 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/screens/lawyer_dashboard_screen.dart';
import 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/screens/lawyer_profile_screen.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_bottom_navbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_lawyer_drawer.dart';

class LawyerBottomNavigationScreen extends ConsumerStatefulWidget {
  const LawyerBottomNavigationScreen({super.key});

  @override
  ConsumerState<LawyerBottomNavigationScreen> createState() =>
      _LawyerBottomNavigationScreenState();
}

class _LawyerBottomNavigationScreenState
    extends ConsumerState<LawyerBottomNavigationScreen> {
  final List<Widget> _screens = [
    const LawyerDashboardScreen(),
    const Center(child: Text("Chat Screen (Coming Soon)")),
    const Center(child: Text("Settings Screen (Coming Soon)")),
    const LawyerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(lawyerBottomNavigationProvider);

    return Scaffold(
      drawer: const CustomLawyerDrawer(),
      backgroundColor: AppColors.kBgDark, // deep dark consistent background
      extendBody: true, // important for glass effect to show behind
      body: _screens[currentIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(lawyerBottomNavigationProvider.notifier).setIndex(index),
        items: [
          BottomNavItem(
            activeIcon: Icons.dashboard_rounded,
            inactiveIcon: Icons.dashboard_outlined,
            label: '',
          ),
          BottomNavItem(
            activeIcon: Icons.chat_rounded,
            inactiveIcon: Icons.chat_outlined,
            label: '',
          ),
          BottomNavItem(
            activeIcon: Icons.settings_rounded,
            inactiveIcon: Icons.settings_outlined,
            label: '',
          ),
          BottomNavItem(
            activeIcon: Icons.person_rounded,
            inactiveIcon: Icons.person_outline_rounded,
            label: '',
          ),
        ],
      ),
    );
  }
}
