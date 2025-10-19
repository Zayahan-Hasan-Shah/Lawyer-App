import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationScreen extends ConsumerStatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  ConsumerState<BottomNavigationScreen> createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState
    extends ConsumerState<BottomNavigationScreen> {
  final List<Widget> _screens = [
    const Center(child: Text('Home Screen')),
    const Center(child: Text('Chat Screen')),
    const Center(child: Text('Video Screen')),
    const Center(child: Text('Search Screen')),
    const Center(child: Text('Notifications Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationProvider);

    return Scaffold(
      body: _screens[currentIndex],

      // 🎥 Floating Action Button (Video)
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(bottomNavigationProvider.notifier).setIndex(2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const CircleBorder(),
        child: Ink(
          padding: EdgeInsets.all(2.w),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.buttonGradientColor,
          ),
          child: const Icon(Icons.video_call, color: Colors.black, size: 32),
        ),
      ),

      // 📍 Center position, slightly lifted
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🟡 Bottom bar
      bottomNavigationBar: _buildBottomNavBar(currentIndex),
    );
  }

  Widget _buildBottomNavBar(int currentIndex) {
    return BottomAppBar(
      surfaceTintColor: AppColors.blackColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 3.h,
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.buttonGradientColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(Icons.home, "Home", 0, currentIndex),
            _navItem(Icons.chat_bubble_outline, "Chat", 1, currentIndex),
            const SizedBox(width: 50), // space for FAB notch
            _navItem(Icons.search, "Search", 3, currentIndex),
            _navItem(
              Icons.notifications_none,
              "Notifications",
              4,
              currentIndex,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, int currentIndex) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => ref.read(bottomNavigationProvider.notifier).setIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.black : Colors.black.withOpacity(0.6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.black.withOpacity(0.6),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
