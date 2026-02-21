import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:lawyer_app/src/providers/student_provider/bottom_navigation_provider/student_bottom_navigation_provider.dart';
import 'package:lawyer_app/src/views/student/bottom_navigation/screens/student_dashboard_screen.dart';
import 'package:lawyer_app/src/views/student/bottom_navigation/screens/certification_screen.dart';
import 'package:lawyer_app/src/views/student/bottom_navigation/screens/tasks_screen.dart';
import 'package:lawyer_app/src/views/student/bottom_navigation/screens/research_screen.dart';
import 'package:lawyer_app/src/views/student/bottom_navigation/screens/student_profile_screen.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_bottom_navbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_student_drawer.dart';

class StudentBottomNavigationScreen extends ConsumerStatefulWidget {
  const StudentBottomNavigationScreen({super.key});

  @override
  ConsumerState<StudentBottomNavigationScreen> createState() =>
      _StudentBottomNavigationScreenState();
}

class _StudentBottomNavigationScreenState
    extends ConsumerState<StudentBottomNavigationScreen> {
  final List<Widget> _screens = [
    const StudentDashboardScreen(),
    const CertificationScreen(),
    const TasksScreen(),
    const ResearchScreen(),
    const StudentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(studentBottomNavigationProvider);

    return Scaffold(
      drawer: const CustomStudentDrawer(),
      backgroundColor: const Color(0xFF08151A), // consistent dark background
      extendBody: true, // important for glass effect to show behind
      body: _screens[currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: CustomBottomNavbar(
          currentIndex: currentIndex,
          onTap: (index) => ref
              .read(studentBottomNavigationProvider.notifier)
              .setIndex(index),
          items: [
            BottomNavItem(
              activeIcon: Icons.dashboard_rounded,
              inactiveIcon: Icons.dashboard_outlined,
              label: '',
            ),
            BottomNavItem(
              activeIcon: Icons.school_rounded,
              inactiveIcon: Icons.school_outlined,
              label: '',
            ),
            BottomNavItem(
              activeIcon: Icons.assignment_rounded,
              inactiveIcon: Icons.assignment_outlined,
              label: '',
            ),
            BottomNavItem(
              activeIcon: Icons.science_rounded,
              inactiveIcon: Icons.science_outlined,
              label: '',
            ),
            BottomNavItem(
              activeIcon: Icons.person_rounded,
              inactiveIcon: Icons.person_outline_rounded,
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
