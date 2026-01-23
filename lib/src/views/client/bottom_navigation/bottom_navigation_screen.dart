import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:lawyer_app/src/providers/client_provider/bottom_navigation_provider/bottom_navigation_provider.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/chat/chat_screen.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/home/home_screen.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/search/search_screen.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/video/video_screen.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_bottom_navbar.dart';
import 'package:lawyer_app/src/views/client/bottom_navigation/screens/notifications/notification_screen.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_client_drawer.dart';

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
      body: _screens[currentIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomBottomNavbar(
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
                label: 'Video',
              ),
              BottomNavItem(
                activeIcon: Icons.search,
                inactiveIcon: Icons.search_outlined,
                label: 'Search',
              ),

              BottomNavItem(
                activeIcon: Icons.notifications,
                inactiveIcon: Icons.notifications_outlined,
                label: 'Notifications',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
