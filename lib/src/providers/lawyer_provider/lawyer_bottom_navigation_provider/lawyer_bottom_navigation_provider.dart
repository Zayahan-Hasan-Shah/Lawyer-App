import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/lawyer_controller/lawyer_bottom_navigation_controller/lawyer_navigation_controller.dart';

final lawyerBottomNavigationProvider =
    StateNotifierProvider<LawyerBottomNavigationController, int>((ref) {
      return LawyerBottomNavigationController();
    });
