import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/student_controller/bottom_navigation_controller/student_bottom_navigation_controller.dart';

final studentBottomNavigationProvider =
    StateNotifierProvider<StudentBottomNavigationController, int>((ref) {
      return StudentBottomNavigationController();
    });
