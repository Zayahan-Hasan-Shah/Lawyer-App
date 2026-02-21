import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/models/student_model/student_model.dart';
import 'package:lawyer_app/src/models/student_model/certification_model.dart';
import 'package:lawyer_app/src/models/student_model/task_model.dart';
import 'package:lawyer_app/src/models/student_model/research_model.dart';

// Student data provider
final studentProvider = StateProvider<StudentModel?>((ref) {
  return null; // Will be set when student logs in
});

// Certifications provider
final certificationsProvider = StateNotifierProvider<CertificationsNotifier, List<CertificationModel>>((ref) {
  return CertificationsNotifier();
});

class CertificationsNotifier extends StateNotifier<List<CertificationModel>> {
  CertificationsNotifier() : super([]);

  void addCertification(CertificationModel certification) {
    state = [...state, certification];
  }

  void updateCertification(CertificationModel updatedCertification) {
    state = state.map((cert) => 
      cert.id == updatedCertification.id ? updatedCertification : cert
    ).toList();
  }

  void removeCertification(String certificationId) {
    state = state.where((cert) => cert.id != certificationId).toList();
  }

  void loadCertifications(List<CertificationModel> certifications) {
    state = certifications;
  }
}

// Tasks provider
final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskModel>>((ref) {
  return TasksNotifier();
});

class TasksNotifier extends StateNotifier<List<TaskModel>> {
  TasksNotifier() : super([]);

  void addTask(TaskModel task) {
    state = [...state, task];
  }

  void updateTask(TaskModel updatedTask) {
    state = state.map((task) => 
      task.id == updatedTask.id ? updatedTask : task
    ).toList();
  }

  void removeTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }

  void markTaskAsComplete(String taskId) {
    state = state.map((task) => 
      task.id == taskId ? TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        dueDate: task.dueDate,
        isCompleted: true,
        priority: task.priority,
      ) : task
    ).toList();
  }

  void loadTasks(List<TaskModel> tasks) {
    state = tasks;
  }

  List<TaskModel> get activeTasks => state.where((task) => !task.isCompleted).toList();
  List<TaskModel> get completedTasks => state.where((task) => task.isCompleted).toList();
}

// Research provider
final researchProvider = StateNotifierProvider<ResearchNotifier, List<ResearchModel>>((ref) {
  return ResearchNotifier();
});

class ResearchNotifier extends StateNotifier<List<ResearchModel>> {
  ResearchNotifier() : super([]);

  void addResearch(ResearchModel research) {
    state = [...state, research];
  }

  void updateResearch(ResearchModel updatedResearch) {
    state = state.map((research) => 
      research.id == updatedResearch.id ? updatedResearch : research
    ).toList();
  }

  void removeResearch(String researchId) {
    state = state.where((research) => research.id != researchId).toList();
  }

  void loadResearch(List<ResearchModel> research) {
    state = research;
  }

  List<ResearchModel> get activeResearch => state.where((research) => research.status == 'active').toList();
  List<ResearchModel> get availableResearch => state.where((research) => research.status == 'available').toList();
}

// Loading states
final studentLoadingProvider = StateProvider<bool>((ref) => false);
final certificationsLoadingProvider = StateProvider<bool>((ref) => false);
final tasksLoadingProvider = StateProvider<bool>((ref) => false);
final researchLoadingProvider = StateProvider<bool>((ref) => false);

// Error states
final studentErrorProvider = StateProvider<String?>((ref) => null);
final certificationsErrorProvider = StateProvider<String?>((ref) => null);
final tasksErrorProvider = StateProvider<String?>((ref) => null);
final researchErrorProvider = StateProvider<String?>((ref) => null);
