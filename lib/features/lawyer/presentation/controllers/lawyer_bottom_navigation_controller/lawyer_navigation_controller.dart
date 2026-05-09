import 'package:flutter_riverpod/legacy.dart';

class LawyerBottomNavigationController extends StateNotifier<int> {
  LawyerBottomNavigationController() : super(0);

  void setIndex(int index) {
    state = index;
  }
}
