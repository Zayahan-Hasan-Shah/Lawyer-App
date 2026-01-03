import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/bottom_navigation_controller/bottom_navigation_controller.dart';

final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationController, int>((ref) {
      return BottomNavigationController();
    });
