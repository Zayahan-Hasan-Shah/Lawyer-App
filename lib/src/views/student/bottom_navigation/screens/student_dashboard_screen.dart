import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/student_model.dart';
import 'package:lawyer_app/src/models/student_model/certification_model.dart';
import 'package:lawyer_app/src/models/student_model/task_model.dart';
import 'package:lawyer_app/src/models/student_model/research_model.dart';
import 'package:lawyer_app/src/providers/student_provider/tasks_provider/task_provider.dart';
import 'package:lawyer_app/src/providers/student_provider/research_provider/research_provider.dart';
import 'package:lawyer_app/src/providers/student_provider/certifications_provider/certification_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/failed_widget.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/cases_tab_button.dart';
import 'package:lawyer_app/src/widgets/student_widgets/empty_state_widget.dart';
import 'package:sizer/sizer.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends ConsumerState<StudentDashboardScreen> {
  int selectedTab = 0;

  // Mock student data
  final StudentModel student = StudentModel(
    id: '1',
    fullName: 'John Doe',
    university: 'Harvard University',
    studyYear: '3rd Year',
    currentProgram: 'Computer Science',
    email: 'john.doe@harvard.edu',
    profileImage: '',
  );

  // Mock certification data
  final List<CertificationModel> certifications = [
    CertificationModel(
      id: '1',
      title: 'Web Development Fundamentals',
      description: 'Learn the basics of HTML, CSS, and JavaScript',
      startDate: '2024-01-15',
      endDate: '2024-03-15',
      certificateImage: '',
      isCompleted: true,
      duration: '2 months',
      instructor: 'John Smith',
      level: 'Beginner',
      skills: ['HTML', 'CSS', 'JavaScript'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(taskControllerProvider.notifier).getAllTasks();
      ref.read(researchControllerProvider.notifier).getAllResearch();
      ref.read(certificationControllerProvider.notifier).getAllCertifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskControllerProvider);
    final researchState = ref.watch(researchControllerProvider);

    final tasks = taskState.when(
      initial: () => <TaskModel>[],
      loading: () => <TaskModel>[],
      failure: (error) => <TaskModel>[],
      success: (data) => data.activeTasks.take(3).toList(),
    );

    final researchTopics = researchState.when(
      initial: () => <ResearchModel>[],
      loading: () => <ResearchModel>[],
      failure: (error) => <ResearchModel>[],
      success: (data) => data.currentResearch,
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

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Header + Tabs
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "Student Dashboard",
                            color: AppColors.kTextPrimary,
                            fontSize: 26.sp,
                            weight: FontWeight.w800,
                          ),
                          SizedBox(height: 0.4.h),
                          CustomText(
                            title: "Manage your academic progress",
                            color: AppColors.kTextSecondary,
                            fontSize: 15.sp,
                          ),
                          SizedBox(height: 2.5.h),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CasesTabButton(
                                  title: 'Details',
                                  index: 0,
                                  selectedTab: selectedTab,
                                  onTap: _onTabChanged,
                                ),
                                SizedBox(width: 4.w),
                                CasesTabButton(
                                  title: 'Certification',
                                  index: 1,
                                  selectedTab: selectedTab,
                                  onTap: _onTabChanged,
                                ),
                                SizedBox(width: 4.w),
                                CasesTabButton(
                                  title: 'Task',
                                  index: 2,
                                  selectedTab: selectedTab,
                                  onTap: _onTabChanged,
                                ),
                                SizedBox(width: 4.w),
                                CasesTabButton(
                                  title: 'Research',
                                  index: 3,
                                  selectedTab: selectedTab,
                                  onTap: _onTabChanged,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Content Area
                    _buildTabContent(selectedTab),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() => selectedTab = index);
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _buildDetailsTab();
      case 1:
        return _buildCertificationTab();
      case 2:
        return _buildTaskTab();
      case 3:
        return _buildResearchTab();
      default:
        return _buildDetailsTab();
    }
  }

  Widget _buildDetailsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kSurface.withOpacity(0.8),
                  AppColors.kSurfaceElevated.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.kEmerald.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8.w,
                      backgroundColor: AppColors.kEmerald.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 6.w,
                        color: AppColors.kEmerald,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: student.fullName,
                            fontSize: 18.sp,
                            weight: FontWeight.w700,
                            color: AppColors.kTextPrimary,
                          ),
                          CustomText(
                            title: student.email,
                            fontSize: 14.sp,
                            color: AppColors.kTextSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                _buildDetailRow('University', student.university),
                _buildDetailRow('Study Year', student.studyYear),
                _buildDetailRow('Current Program', student.currentProgram),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: label,
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
            weight: FontWeight.w500,
          ),
          SizedBox(height: 0.5.h),
          CustomText(
            title: value,
            fontSize: 16.sp,
            color: AppColors.kTextPrimary,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationTab() {
    final certificationState = ref.watch(certificationControllerProvider);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: certificationState.when(
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
        success: (data) {
          final completedCertifications = data.completedCertifications;
          if (completedCertifications.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.school_outlined,
              title: "No Certifications Yet",
              subtitle: "Start learning and earn your first certification",
              buttonText: "Browse Certifications",
              onButtonPressed: () {
                // Navigate to certification screen (index 1 in bottom nav)
              },
            );
          }
          return Column(
            children: completedCertifications.map((certification) => _buildCertificationCard(certification)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCertificationCard(CertificationModel cert) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: cert.title,
            fontSize: 16.sp,
            weight: FontWeight.w600,
            color: AppColors.kTextPrimary,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: cert.description,
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: AppColors.kEmerald),
              SizedBox(width: 1.w),
              CustomText(
                title: "${cert.startDate} - ${cert.endDate}",
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTab() {
    final taskState = ref.watch(taskControllerProvider);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
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
        success: (data) {
          final activeTasks = data.activeTasks.take(3).toList();
          if (activeTasks.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.inbox_outlined,
              title: "No active tasks",
              subtitle: "All tasks are up to date!",
            );
          }
          return Column(
            children: activeTasks.map((task) => _buildTaskCard(task)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final priorityColor = task.priority == 'high' 
        ? Colors.redAccent 
        : task.priority == 'medium' 
            ? Colors.orangeAccent 
            : Colors.greenAccent;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  title: task.title,
                  fontSize: 16.sp,
                  weight: FontWeight.w600,
                  color: AppColors.kTextPrimary,
                ),
              ),
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
            ],
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: task.description,
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
          ),
          SizedBox(height: 1.h),
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
    );
  }

  Widget _buildResearchTab() {
    final researchState = ref.watch(researchControllerProvider);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: researchState.when(
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
        success: (data) {
          if (data.currentResearch.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.science_outlined,
              title: "No Research Topics Yet",
              subtitle: "Start exploring research areas",
              buttonText: "Select Research Topics",
              onButtonPressed: () {
                // Navigate to research screen (index 3 in bottom nav)
              },
            );
          }
          return Column(
            children: data.currentResearch.map((research) => _buildResearchCard(research)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildResearchCard(ResearchModel research) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: research.title,
            fontSize: 16.sp,
            weight: FontWeight.w600,
            color: AppColors.kTextPrimary,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: research.description,
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(Icons.person, size: 14, color: AppColors.kEmerald),
              SizedBox(width: 1.w),
              CustomText(
                title: research.supervisor,
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
              SizedBox(width: 4.w),
              Icon(Icons.calendar_today, size: 14, color: AppColors.kEmerald),
              SizedBox(width: 1.w),
              CustomText(
                title: research.startDate,
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
