import 'package:lawyer_app/src/models/student_model/task_model.dart';

sealed class TaskStates {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(String error) failure,
    required R Function(AllTasksResponse data) success,
  }) {
    if (this is TaskInitialState) return initial();
    if (this is TaskLoadingState) return loading();
    if (this is TaskFailureState) {
      return failure((this as TaskFailureState).error);
    }
    if (this is TaskSuccessState) {
      return success((this as TaskSuccessState).data);
    }
    throw Exception('Unhandled state: $this');
  }
}

class TaskInitialState extends TaskStates {}

class TaskLoadingState extends TaskStates {}

class TaskSuccessState extends TaskStates {
  final AllTasksResponse data;
  TaskSuccessState({required this.data});
}

class TaskFailureState extends TaskStates {
  final String error;
  TaskFailureState({required this.error});
}
