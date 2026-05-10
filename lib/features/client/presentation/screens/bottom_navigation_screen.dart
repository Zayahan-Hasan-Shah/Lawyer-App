import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/features/client/presentation/providers/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:lawyer_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/home/home_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/search/search_screen.dart';
import 'package:lawyer_app/features/client/presentation/screens/video/video_screen.dart';
import 'package:lawyer_app/shared/widgets/custom_bottom_navbar.dart';
import 'package:lawyer_app/features/client/presentation/screens/notifications/notification_screen.dart';
import 'package:lawyer_app/shared/widgets/custom_client_drawer.dart';
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
    ChatListScreen(),
    VideoScreen(),
    SearchScreen(),
    NotificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationProvider);
    return Scaffold(
      drawer: const CustomClientDrawer(),
      extendBody: true, // to make FAB overlap cleanly
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomBottomNavbar(
              currentIndex: currentIndex,
              onTap: (index) =>
                  ref.read(bottomNavigationProvider.notifier).setIndex(index),
              items: [
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.home, size: 3.h),
                  icon: Icon(Icons.home_outlined, size: 3.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.chat, size: 3.h),
                  icon: Icon(Icons.chat_outlined, size: 3.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.video_call, size: 3.h),
                  icon: Icon(Icons.video_call_outlined, size: 3.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.search, size: 3.h),
                  icon: Icon(Icons.search_outlined, size: 3.h),
                  label: '',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.notifications, size: 3.h),
                  icon: Icon(Icons.notifications_outlined, size: 3.h),
                  label: '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
