import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/student_tasks_data.dart';
import 'package:lawyer_app/src/models/student_model/task_model.dart';
import 'package:lawyer_app/src/states/student_states/task_states.dart';

class TaskController extends StateNotifier<TaskStates> {
  TaskController() : super(TaskInitialState());

  Future<void> getAllTasks() async {
    state = TaskLoadingState();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = mockStudentTasksData;
      if (response['status'] != 200) {
        state = TaskFailureState(error: 'Failed to load tasks');
        return;
      }

      final data = response['data'] as Map<String, dynamic>;

      final activeList = (data['active_tasks'] as List)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final completedList = (data['completed_tasks'] as List)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final allTasks = AllTasksResponse(
        activeTasks: activeList,
        completedTasks: completedList,
      );

      state = TaskSuccessState(data: allTasks);
    } catch (e, stack) {
      log('Get All Tasks → Error: $e\n$stack');
      state = TaskFailureState(error: 'Unable to load tasks data');
    }
  }

  Future<void> markTaskAsComplete(String taskId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (state is TaskSuccessState) {
        final currentData = (state as TaskSuccessState).data;
        final activeTasks = List<TaskModel>.from(currentData.activeTasks);
        final completedTasks = List<TaskModel>.from(currentData.completedTasks);

        final taskToComplete = activeTasks.firstWhere(
          (task) => task.id == taskId,
          orElse: () => throw Exception('Task not found'),
        );

        // Move task from active to completed
        final completedTask = TaskModel(
          id: taskToComplete.id,
          title: taskToComplete.title,
          description: taskToComplete.description,
          category: taskToComplete.category,
          dueDate: taskToComplete.dueDate,
          isCompleted: true,
          priority: taskToComplete.priority,
        );

        activeTasks.removeWhere((task) => task.id == taskId);
        completedTasks.add(completedTask);

        final updatedData = AllTasksResponse(
          activeTasks: activeTasks,
          completedTasks: completedTasks,
        );

        state = TaskSuccessState(data: updatedData);
      }
    } catch (e, stack) {
      log('Mark Task Complete → Error: $e\n$stack');
      state = TaskFailureState(error: 'Failed to update task status');
    }
  }

  Future<void> refreshTasks() async {
    await getAllTasks();
  }
}
