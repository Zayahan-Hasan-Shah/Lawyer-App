import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/research_model.dart';
import 'package:lawyer_app/src/providers/student_provider/research_provider/research_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/failed_widget.dart';
import 'package:lawyer_app/src/widgets/student_widgets/research_item_widget.dart';
import 'package:lawyer_app/src/widgets/student_widgets/empty_state_widget.dart';
import 'package:sizer/sizer.dart';

class ResearchScreen extends ConsumerStatefulWidget {
  const ResearchScreen({super.key});

  @override
  ConsumerState<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends ConsumerState<ResearchScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(researchControllerProvider.notifier).getAllResearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final researchState = ref.watch(researchControllerProvider);

    final currentResearch = researchState.when(
      initial: () => <ResearchModel>[],
      loading: () => <ResearchModel>[],
      failure: (error) => <ResearchModel>[],
      success: (data) => data.currentResearch,
    );

    final availableResearch = researchState.when(
      initial: () => <ResearchModel>[],
      loading: () => <ResearchModel>[],
      failure: (error) => <ResearchModel>[],
      success: (data) => data.availableResearch,
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
                    title: "Research",
                    color: AppColors.kTextPrimary,
                    fontSize: 26.sp,
                    weight: FontWeight.w800,
                  ),
                  SizedBox(height: 0.4.h),
                  CustomText(
                    title: "Explore and contribute to cutting-edge research",
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),

            Expanded(
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
                success: (data) => SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.currentResearch.isNotEmpty) ...[
                        CustomText(
                          title: "Current Research",
                          fontSize: 18.sp,
                          weight: FontWeight.w600,
                          color: AppColors.kTextPrimary,
                        ),
                        SizedBox(height: 2.h),
                        ...data.currentResearch.map((research) => ResearchItemWidget(
                          research: research,
                          isCurrent: true,
                          onTap: () => _showResearchDetails(context, research, true),
                        )),
                        SizedBox(height: 3.h),
                      ],

                      CustomText(
                        title: "Available Research Topics",
                        fontSize: 18.sp,
                        weight: FontWeight.w600,
                        color: AppColors.kTextPrimary,
                      ),
                      SizedBox(height: 2.h),
                      if (data.availableResearch.isEmpty)
                        EmptyStateWidget(
                          icon: Icons.lightbulb_outline,
                          title: "No available research topics",
                          subtitle: "Check back later for new research opportunities",
                        )
                      else
                        ...data.availableResearch.map((research) => ResearchItemWidget(
                          research: research,
                          isCurrent: false,
                          onTap: () => _showResearchDetails(context, research, false),
                          onJoin: () => _joinResearch(context, research),
                        )),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _joinResearch(BuildContext context, ResearchModel research) {
    ref.read(researchControllerProvider.notifier).joinResearch(research.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully joined "${research.title}"'),
        backgroundColor: AppColors.kEmerald,
      ),
    );
  }

  void _showResearchDetails(BuildContext context, ResearchModel research, bool isCurrent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              isCurrent ? Icons.science : Icons.lightbulb_outline,
              color: AppColors.kEmerald,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                research.title,
                style: TextStyle(
                  color: AppColors.kTextPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              research.description,
              style: TextStyle(
                color: AppColors.kTextSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 2.h),
            _buildDetailRow("Supervisor", research.supervisor, Icons.person),
            SizedBox(height: 1.h),
            _buildDetailRow(
              isCurrent ? "Started Date" : "Available Date", 
              research.startDate, 
              Icons.calendar_today
            ),
            SizedBox(height: 1.h),
            _buildDetailRow("Status", research.status.toUpperCase(), Icons.info),
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
          if (!isCurrent)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _joinResearch(context, research);
              },
              child: Text(
                'Join Research',
                style: TextStyle(color: AppColors.kEmerald),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.kEmerald),
        SizedBox(width: 2.w),
        Text(
          "$label: ",
          style: TextStyle(
            color: AppColors.kTextSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}
