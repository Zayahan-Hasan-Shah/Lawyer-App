// lawyer_state.dart
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';

sealed class LawyerState {
  const LawyerState();
}

class LawyerInitial extends LawyerState {}

class LawyerLoading extends LawyerState {}

class LawyerLoaded extends LawyerState {
  final List<LawyerModel> lawyers;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const LawyerLoaded({
    required this.lawyers,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  LawyerLoaded copyWith({
    List<LawyerModel>? lawyers,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return LawyerLoaded(
      lawyers: lawyers ?? this.lawyers,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class LawyerError extends LawyerState {
  final String message;
  const LawyerError(this.message);
}
