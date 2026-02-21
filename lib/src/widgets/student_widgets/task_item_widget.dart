import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/task_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final bool isCompleted;
  final VoidCallback? onTap;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = task.priority == 'high' 
        ? Colors.redAccent 
        : task.priority == 'medium' 
            ? Colors.orangeAccent 
            : Colors.greenAccent;

    final categoryIcon = _getCategoryIcon(task.category);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted 
              ? AppColors.kEmerald.withOpacity(0.3)
              : priorityColor.withOpacity(0.3),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      categoryIcon,
                      color: AppColors.kEmerald,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: CustomText(
                        title: task.title,
                        fontSize: 16.sp,
                        weight: FontWeight.w600,
                        color: AppColors.kTextPrimary,
                      ),
                    ),
                    if (!isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText(
                          title: task.priority.toUpperCase(),
                          fontSize: 10.sp,
                          color: priorityColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    if (isCompleted)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.kEmerald,
                        size: 6.w,
                      ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                CustomText(
                  title: task.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(Icons.category, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: task.category,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.calendar_today, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: task.dueDate,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'certification':
        return Icons.school;
      case 'internship':
        return Icons.business_center;
      case 'program':
        return Icons.code;
      case 'research':
        return Icons.science;
      default:
        return Icons.assignment;
    }
  }
}
