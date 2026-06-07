import 'dart:developer';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';
import 'package:lawyer_app/features/lawyer/domain/usecases/get_lawyers_usecase.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/lawyer_state.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';

class LawyerController extends StateNotifier<LawyerState> {
  final GetLawyersUseCase _getLawyersUseCase;

  LawyerController({GetLawyersUseCase? useCase})
      : _getLawyersUseCase = useCase ?? sl<GetLawyersUseCase>(),
        super(LawyerInitial());

  static const int _pageSize = 10;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  Future<void> loadLawyers({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      state = LawyerLoading();
    } else if (state is LawyerLoaded && !(state as LawyerLoaded).hasMore) {
      return;
    } else if (_isLoadingMore) {
      return;
    }

    _isLoadingMore = true;

    try {
      final PaginatedLawyersEntity paginatedData = await _getLawyersUseCase.execute(_currentPage, _pageSize);

      final newLawyers = paginatedData.lawyers;
      final int totalPages = paginatedData.totalPages;

      if (isRefresh || state is! LawyerLoaded) {
        state = LawyerLoaded(
          lawyers: newLawyers,
          currentPage: _currentPage,
          totalPages: totalPages,
          hasMore: _currentPage < totalPages,
        );
      } else {
        final current = state as LawyerLoaded;
        state = current.copyWith(
          lawyers: [...current.lawyers, ...newLawyers],
          currentPage: _currentPage,
          hasMore: _currentPage < totalPages,
        );
      }

      _currentPage++;
    } on ApiException catch (e) {
      log('LawyerController API Error: ${e.message}');
      state = LawyerError(e.message);
    } catch (e, st) {
      log('LawyerController Unexpected Error: $e');
      log('$st');
      state = LawyerError('Network error. Please try again.');
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMore() => loadLawyers();
  Future<void> refresh() => loadLawyers(isRefresh: true);
}
