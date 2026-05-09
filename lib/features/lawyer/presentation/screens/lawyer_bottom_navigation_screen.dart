import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/lawyer/presentation/providers/lawyer_bottom_navigation_provider/lawyer_bottom_navigation_provider.dart';
import 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_dashboard_screen.dart';
import 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_profile_screen.dart';
import 'package:lawyer_app/shared/widgets/custom_bottom_navbar.dart';
import 'package:lawyer_app/shared/widgets/custom_lawyer_drawer.dart';

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
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CustomBottomNavbar(
          currentIndex: currentIndex,
          onTap: (index) => ref
              .read(lawyerBottomNavigationProvider.notifier)
              .setIndex(index),
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.dashboard_rounded),
              icon: Icon(Icons.dashboard_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.chat_rounded),
              icon: Icon(Icons.chat_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.settings_rounded),
              icon: Icon(Icons.settings_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person_rounded),
              icon: Icon(Icons.person_outline_rounded),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

