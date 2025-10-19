import 'package:flutter_riverpod/legacy.dart';

class BottomNavigationController extends StateNotifier<int> {
  BottomNavigationController() : super(0);

  void setIndex(int index) {
    state = index;
  }
}
