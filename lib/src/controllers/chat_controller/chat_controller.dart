import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';

class SelectedLawyerNotifier extends StateNotifier<LawyerModel?> {
  SelectedLawyerNotifier() : super(null);

  void setLawyer(LawyerModel lawyer) {
    state = lawyer;
  }

  void clear() {
    state = null;
  }
}

// Global provider
final selectedLawyerProvider =
    StateNotifierProvider<SelectedLawyerNotifier, LawyerModel?>((ref) {
      return SelectedLawyerNotifier();
    });
