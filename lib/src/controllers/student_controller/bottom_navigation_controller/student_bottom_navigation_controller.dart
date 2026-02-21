import 'package:flutter_riverpod/legacy.dart';

class StudentBottomNavigationController extends StateNotifier<int> {
  StudentBottomNavigationController() : super(0);

  void setIndex(int index) {
    state = index;
  }
}
