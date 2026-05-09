import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/presentation/controllers/lawyer_bottom_navigation_controller/lawyer_navigation_controller.dart';

final lawyerBottomNavigationProvider =
    StateNotifierProvider<LawyerBottomNavigationController, int>((ref) {
      return LawyerBottomNavigationController();
    });

