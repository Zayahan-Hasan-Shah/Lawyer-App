import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/data/models/lawyer_model.dart';

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

