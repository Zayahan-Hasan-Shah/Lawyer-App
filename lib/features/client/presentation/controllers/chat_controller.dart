import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';

class SelectedLawyerNotifier extends StateNotifier<LawyerEntity?> {
  SelectedLawyerNotifier() : super(null);

  void setLawyer(LawyerEntity lawyer) {
    state = lawyer;
  }

  void clear() {
    state = null;
  }
}

// Global provider
final selectedLawyerProvider =
    StateNotifierProvider<SelectedLawyerNotifier, LawyerEntity?>((ref) {
      return SelectedLawyerNotifier();
    });
