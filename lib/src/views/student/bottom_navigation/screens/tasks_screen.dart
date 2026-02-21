import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/task_model.dart';
import 'package:lawyer_app/src/providers/student_provider/tasks_provider/task_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/failed_widget.dart';
import 'package:lawyer_app/src/widgets/student_widgets/task_item_widget.dart';
import 'package:lawyer_app/src/widgets/student_widgets/empty_state_widget.dart';
import 'package:sizer/sizer.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(taskControllerProvider.notifier).getAllTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskControllerProvider);

    final activeTasks = taskState.when(
      initial: () => <TaskModel>[],
      loading: () => <TaskModel>[],
      failure: (error) => <TaskModel>[],
      success: (data) => data.activeTasks,
    );

    final completedTasks = taskState.when(
      initial: () => <TaskModel>[],
      loading: () => <TaskModel>[],
      failure: (error) => <TaskModel>[],
      success: (data) => data.completedTasks,
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1117),
            Color(0xFF0A1F24),
            Color(0xFF08151A),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              logoImage: AppAssets.logoImage,
              backgroundColor: Colors.transparent,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  CustomText(
                    title: "Tasks",
                    color: AppColors.kTextPrimary,
                    fontSize: 26.sp,
                    weight: FontWeight.w800,
                  ),
                  SizedBox(height: 0.4.h),
                  CustomText(
                    title: "Manage your academic and professional tasks",
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: AppColors.kSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.kEmerald.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: AppColors.kEmerald,
                unselectedLabelColor: AppColors.kTextSecondary,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pending_actions, size: 18),
                        SizedBox(width: 1.w),
                        Text('Active (${activeTasks.length})'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 18),
                        SizedBox(width: 1.w),
                        Text('Completed (${completedTasks.length})'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            Expanded(
              child: taskState.when(
                initial: () => const SizedBox(),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.kEmerald,
                    strokeWidth: 4,
                  ),
                ),
                failure: (error) => Center(
                  child: FailedWidget(
                    text: error,
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                success: (data) => TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTasksList(activeTasks, false),
                    _buildTasksList(completedTasks, true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<TaskModel> tasks, bool isCompleted) {
    if (tasks.isEmpty) {
      return EmptyStateWidget(
        icon: isCompleted ? Icons.check_circle_outline : Icons.inbox_outlined,
        title: isCompleted ? "No completed tasks" : "No active tasks",
        subtitle: isCompleted 
            ? "Complete some tasks to see them here" 
            : "All tasks are up to date!",
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskItemWidget(
          task: task,
          isCompleted: isCompleted,
          onTap: () => _showTaskDetails(context, task),
        );
      },
    );
  }

  void _showTaskDetails(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(
                color: AppColors.kTextSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                Text(
                  task.category,
                  style: TextStyle(
                    color: AppColors.kTextPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                Text(
                  'Due: ${task.dueDate}',
                  style: TextStyle(
                    color: AppColors.kTextPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(Icons.flag, size: 16, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                Text(
                  'Priority: ${task.priority.toUpperCase()}',
                  style: TextStyle(
                    color: task.priority == 'high' 
                        ? Colors.redAccent 
                        : task.priority == 'medium' 
                            ? Colors.orangeAccent 
                            : Colors.greenAccent,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
          ),
          if (!task.isCompleted)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _markTaskAsComplete(task);
              },
              child: Text(
                'Mark Complete',
                style: TextStyle(color: AppColors.kEmerald),
              ),
            ),
        ],
      ),
    );
  }

  void _markTaskAsComplete(TaskModel task) {
    ref.read(taskControllerProvider.notifier).markTaskAsComplete(task.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" marked as complete!'),
        backgroundColor: AppColors.kEmerald,
      ),
    );
  }
}
