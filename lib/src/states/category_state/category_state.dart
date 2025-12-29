import 'package:lawyer_app/src/models/client_model/cases_categories_model/case_categories_model.dart';

sealed class CategoryState {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(List<CaseCategoriesModel> data) success,
  }) {
    if (this is CategoryInitialState) return initial();
    if (this is CategoryLoadingState) return loading();
    if (this is CategoryFailureState) {
      return failure((this as CategoryFailureState).error);
    }
    if (this is CategorySuccessState) {
      return success((this as CategorySuccessState).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategorySuccessState extends CategoryState {
  final List<CaseCategoriesModel> data;
  CategorySuccessState({required this.data});
}

class CategoryFailureState extends CategoryState {
  final String error;
  CategoryFailureState({required this.error});
}
