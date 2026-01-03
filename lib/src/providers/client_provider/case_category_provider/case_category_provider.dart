import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/client_controller/categories_controller/categories_controller.dart';
import 'package:lawyer_app/src/states/client_states/category_state/category_state.dart';

final caseCategoryProvider =
    StateNotifierProvider<CategoriesController, CategoryState>(
      (ref) => CategoriesController(),
    );
