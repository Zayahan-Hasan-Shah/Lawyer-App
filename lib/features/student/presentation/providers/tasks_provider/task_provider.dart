import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/student/presentation/controllers/tasks_controller/task_controller.dart';
import 'package:lawyer_app/features/student/presentation/states/task_states.dart';

final taskControllerProvider =
    StateNotifierProvider<TaskController, TaskStates>((ref) {
  return TaskController();
});

