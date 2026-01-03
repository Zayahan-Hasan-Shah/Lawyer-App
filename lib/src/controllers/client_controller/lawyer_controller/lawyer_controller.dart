import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/constants/api_url.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';
import 'package:lawyer_app/src/states/client_states/lawyer_states/lawyer_state.dart';
import 'package:http/http.dart' as http;

class LawyerController extends StateNotifier<LawyerState> {
  LawyerController() : super(LawyerInitial());

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
      final token = await StorageService.instance.getAccessToken();

      final uri = Uri.parse(
        '${ApiUrl.getAllLayersUrl}?pageNumber=$_currentPage&pageSize=$_pageSize',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("=== GET LAWYER API ===");
      log("URL : ${ApiUrl.getAllLayersUrl}");
      log("STATUS : ${response.statusCode}");
      log("RES  : ${response.body}");
      log("==================");

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final data = jsonMap['data'];
        final List<dynamic> items = data['items'];
        final int totalPages = data['totalPages'];

        final newLawyers = items
            .map((e) => LawyerModel.fromJson(e as Map<String, dynamic>))
            .toList();

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
      } else {
        state = LawyerError('Server error: ${response.statusCode}');
      }
    } catch (e, st) {
      log('LawyerController → $e');
      log('$st');
      state = LawyerError('Network error. Please try again.');
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMore() => loadLawyers();
  Future<void> refresh() => loadLawyers(isRefresh: true);
}
