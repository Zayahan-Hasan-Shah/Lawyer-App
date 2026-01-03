import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/cases_categories.dart';
import 'package:lawyer_app/src/models/client_model/cases_categories_model/case_categories_model.dart';
import 'package:lawyer_app/src/states/client_states/category_state/category_state.dart';

class CategoriesController extends StateNotifier<CategoryState> {
  CategoriesController() : super(CategoryInitialState());

  Future<void> getCategories() async {
    state = CategoryInitialState();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = caseCategories;
      if (response.isEmpty) {
        throw Exception("No categories found");
      }
      if (response[0]['status'] != 200) {
        state = CategoryFailureState(error: "Failed to load categories");
      }
      final data = response[0]['data'] as List;
      final categoriesList = data
          .map((e) => CaseCategoriesModel.fromJson(e as Map<String, dynamic>))
          .toList();
      final caseCategoriesModel = CaseCategoriesModelList(
        categories: categoriesList,
      );
      state = CategorySuccessState(data: caseCategoriesModel.categories);
    } catch (e) {
      log("Error in getCategories: $e");
      state = CategoryFailureState(error: "Unable to Load Categories");
    }
  }
}
