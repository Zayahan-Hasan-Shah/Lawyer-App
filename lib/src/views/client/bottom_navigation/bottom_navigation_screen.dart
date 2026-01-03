import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:lawyer_app/src/providers/client_provider/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/chat/chat_screen.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/home/home_screen.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/search/search_screen.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_bottom_navbar.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const BottomNavigationScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<BottomNavigationScreen> createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState
    extends ConsumerState<BottomNavigationScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    ChatScreen(),
    const Center(child: Text('Video Screen')),
    SearchScreen(),
    const Center(child: Text('Notifications Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationProvider);

    return Scaffold(
      extendBody: true, // to make FAB overlap cleanly
      body: _screens[currentIndex],

      floatingActionButton: Container(
        height: 8.h,
        width: 8.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.buttonGradientColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () =>
              ref.read(bottomNavigationProvider.notifier).setIndex(2),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Icon(Icons.videocam, color: Colors.black, size: 3.5.h),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,

      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(bottomNavigationProvider.notifier).setIndex(index),
        items: [
          BottomNavItem(
            activeIcon: Icons.home,
            inactiveIcon: Icons.home_outlined,
            label: 'Home',
          ),
          BottomNavItem(
            activeIcon: Icons.chat,
            inactiveIcon: Icons.chat_outlined,
            label: 'Chat',
          ),
          BottomNavItem(
            activeIcon: Icons.video_call,
            inactiveIcon: Icons.video_call_outlined,
            label: '',
          ),
          // BottomNavItem(
          //   activeIcon: Icons.search,
          //   inactiveIcon: Icons.search_outlined,
          //   label: 'Search',
          // ),
          BottomNavItem(
            activeIcon: Icons.notifications,
            inactiveIcon: Icons.notifications_outlined,
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
