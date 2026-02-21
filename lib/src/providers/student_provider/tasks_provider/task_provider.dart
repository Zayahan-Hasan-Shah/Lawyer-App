import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/student_controller/tasks_controller/task_controller.dart';
import 'package:lawyer_app/src/states/student_states/task_states.dart';

final taskControllerProvider =
    StateNotifierProvider<TaskController, TaskStates>((ref) {
  return TaskController();
});
