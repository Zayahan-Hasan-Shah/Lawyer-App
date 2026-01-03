import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/screens/lawyer_dashboard_screen.dart';

class LawyerBottomNavigationScreen extends ConsumerStatefulWidget {
  const LawyerBottomNavigationScreen({super.key});

  @override
  ConsumerState<LawyerBottomNavigationScreen> createState() =>
      _LawyerBottomNavigationScreenState();
}

class _LawyerBottomNavigationScreenState
    extends ConsumerState<LawyerBottomNavigationScreen> {
  final List<Widget> _screens = [LawyerDashboardScreen()];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
