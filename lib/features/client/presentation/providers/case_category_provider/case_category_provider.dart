import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/client/presentation/controllers/categories_controller/categories_controller.dart';
import 'package:lawyer_app/features/client/presentation/states/category_state/category_state.dart';

final caseCategoryProvider =
    StateNotifierProvider<CategoriesController, CategoryState>(
      (ref) => CategoriesController(),
    );

