import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/features/client/presentation/providers/client_cases_provider/client_case_provider.dart';
import 'package:lawyer_app/features/lawyer/presentation/providers/lawyer_cases_provider/lawyer_case_provider.dart';
import 'package:lawyer_app/services/notification_services/callkit_service.dart';
import 'package:lawyer_app/services/notification_services/notification_service.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

enum JoinStatus { valid, tooEarly, tooLate }

class JoinValidationResult {
  final JoinStatus status;
  final String title;
  final String message;

  JoinValidationResult({
    required this.status,
    required this.title,
    required this.message,
  });
}

class VideoListScreen extends ConsumerStatefulWidget {
  const VideoListScreen({super.key});

  @override
  ConsumerState<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends ConsumerState<VideoListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _userType;
  bool _isLoadingUserType = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserTypeAndFetchData();
  }

  Future<void> _loadUserTypeAndFetchData() async {
    try {
      final type = await StorageService.instance.read(AppKeys.userTypeKey);
      setState(() {
        _userType = type;
        _isLoadingUserType = false;
      });

      if (type?.toLowerCase() == 'lawyer') {
        ref.read(lawyerCaseControllerProvider.notifier).getAllCases();
      } else {
        ref.read(caseControllerProvider.notifier).getAllCases();
      }
    } catch (e) {
      log("Error loading user type: $e");
      setState(() {
        _isLoadingUserType = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    if (_userType?.toLowerCase() == 'lawyer') {
      await ref.read(lawyerCaseControllerProvider.notifier).getAllCases();
    } else {
      await ref.read(caseControllerProvider.notifier).getAllCases();
    }
  }

  void _scheduleReminders(List<dynamic> videoCases) async {
    try {
      for (final c in videoCases) {
        final dateStr = c.hearingDate;
        if (dateStr != null) {
          final date = DateTime.tryParse(dateStr);
          if (date != null && date.isAfter(DateTime.now())) {
            await NotificationService().scheduleAppointmentReminders(
              appointmentId: c.id,
              title: "Upcoming Video Consultation",
              body: "Your consultation for case ${c.caseNo} is starting soon.",
              appointmentTime: date,
            );
          }
        }
      }
    } catch (e) {
      log("Error scheduling reminders: $e");
    }
  }

  JoinValidationResult validateJoiningWindow(DateTime appointmentTime, bool isLawyer) {
    final now = DateTime.now();
    final allowedStartTime = appointmentTime.subtract(const Duration(minutes: 2));
    final allowedEndTime = appointmentTime.add(const Duration(minutes: 10));

    if (now.isBefore(allowedStartTime)) {
      return JoinValidationResult(
        status: JoinStatus.tooEarly,
        title: "Appointment Not Started",
        message: isLawyer
            ? "This consultation has not started yet.\nYou can join the meeting beginning 2 minutes before the scheduled appointment time."
            : "Your video consultation has not started yet.\nYou can join the meeting beginning 2 minutes before the scheduled appointment time.",
      );
    } else if (now.isAfter(allowedEndTime)) {
      return JoinValidationResult(
        status: JoinStatus.tooLate,
        title: "Appointment Expired",
        message: isLawyer
            ? "The joining window for this appointment has expired."
            : "The joining window for this video consultation has expired.\nPlease contact support or your assigned lawyer if you require assistance.",
      );
    } else {
      return JoinValidationResult(
        status: JoinStatus.valid,
        title: "",
        message: "",
      );
    }
  }

  void _handleJoinCall(dynamic item, bool isLawyer) {
    final date = DateTime.tryParse(item.hearingDate ?? '') ?? DateTime.now();
    final validation = validateJoiningWindow(date, isLawyer);

    if (validation.status == JoinStatus.tooEarly || validation.status == JoinStatus.tooLate) {
      _showValidationDialog(validation.title, validation.message);
    } else {
      final participantName = isLawyer 
          ? item.client 
          : (item.lawyerName ?? item.advocate ?? 'Advocate');
      _initiateCallFlow(participantName);
    }
  }

  void _showValidationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: CustomText(
          title: title,
          fontSize: 18.sp,
          weight: FontWeight.bold,
          color: AppColors.kTextPrimary,
        ),
        content: CustomText(
          title: message,
          fontSize: 14.sp,
          color: AppColors.kTextSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.kGold, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUserType) {
      return const Scaffold(
        backgroundColor: AppColors.kBgDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.kGold)),
      );
    }

    final isLawyer = _userType?.toLowerCase() == 'lawyer';

    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Video Appointments",
          fontSize: 22.sp,
          weight: FontWeight.w800,
          color: AppColors.kTextPrimary,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.kGold,
          labelColor: AppColors.kGold,
          unselectedLabelColor: AppColors.kTextSecondary,
          labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Incoming"),
            Tab(text: "Today"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.kGold,
        backgroundColor: AppColors.kSurface,
        child: isLawyer ? _buildLawyerFlow() : _buildClientFlow(),
      ),
    );
  }

  Widget _buildClientFlow() {
    final caseState = ref.watch(caseControllerProvider);

    return caseState.when(
      initial: () => const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
      failure: (error) => _buildErrorState(error),
      success: (data) {
        final allCases = [...data.pendingCases, ...data.disposedCases];
        
        // Filter for Video Calling cases only
        final clientVideoCases = allCases.where((c) {
          final type = c.appointmentType?.toLowerCase() ?? '';
          return type.contains('video');
        }).toList();

        // Filter for cases with assigned lawyers
        final assignedVideoCases = clientVideoCases.where((c) {
          return c.lawyerId != null && c.lawyerName != 'Not Assigned';
        }).toList();

        // Business Rule: If the client has Video Calling cases but no lawyer has been assigned yet,
        // show a custom empty state message instead of loading empty lists or placeholder cards.
        if (assignedVideoCases.isEmpty) {
          return _buildEmptyState(
            "No video appointments are available yet.\nYour case is awaiting lawyer assignment.",
          );
        }

        // Schedule notification reminders automatically
        _scheduleReminders(assignedVideoCases);

        return _buildCategorizedTabs(assignedVideoCases, isLawyer: false);
      },
    );
  }

  Widget _buildLawyerFlow() {
    final caseState = ref.watch(lawyerCaseControllerProvider);

    return caseState.when(
      initial: () => const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
      failure: (error) => _buildErrorState(error),
      success: (data) {
        final allCases = [...data.pendingCases, ...data.disposedCases];
        final videoCases = allCases.where((c) {
          final type = c.appointmentType.toLowerCase();
          return type.contains('video');
        }).toList();

        _scheduleReminders(videoCases);

        return _buildCategorizedTabs(videoCases, isLawyer: true);
      },
    );
  }

  Widget _buildCategorizedTabs(List<dynamic> cases, {required bool isLawyer}) {
    final now = DateTime.now();

    // 1. Today: scheduled for today AND the 10-minute expiry window has not passed yet
    final todayList = cases.where((c) {
      final date = DateTime.tryParse(c.hearingDate ?? '');
      if (date == null) return false;
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      final isExpired = now.isAfter(date.add(const Duration(minutes: 10)));
      return isToday && !isExpired;
    }).toList();

    // 2. Incoming: in the future (excluding today)
    final incomingList = cases.where((c) {
      final date = DateTime.tryParse(c.hearingDate ?? '');
      if (date == null) return false;
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      return date.isAfter(now) && !isToday;
    }).toList();

    // 3. Past: the 10-minute joining window has expired (or past date)
    final pastList = cases.where((c) {
      final date = DateTime.tryParse(c.hearingDate ?? '');
      if (date == null) return false;
      final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      if (isToday) {
        return now.isAfter(date.add(const Duration(minutes: 10)));
      }
      return date.isBefore(now);
    }).toList();

    return TabBarView(
      controller: _tabController,
      children: [
        _buildList(incomingList, isPast: false, isLawyer: isLawyer),
        _buildList(todayList, isPast: false, isLawyer: isLawyer),
        _buildList(pastList, isPast: true, isLawyer: isLawyer),
      ],
    );
  }

  Widget _buildList(List<dynamic> list, {required bool isPast, required bool isLawyer}) {
    if (list.isEmpty) {
      return _buildEmptyState("No Appointments Found");
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(5.w),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final date = DateTime.tryParse(item.hearingDate ?? '') ?? DateTime.now();
        final formattedDate = DateFormat('dd MMMM yyyy').format(date);
        final formattedTime = DateFormat('hh:mm a').format(date);

        final participantName = isLawyer ? item.client : (item.lawyerName ?? item.advocate ?? 'Advocate');

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isPast ? AppColors.kSurface.withOpacity(0.4) : AppColors.kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPast 
                  ? Colors.white12 
                  : AppColors.kGold.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 3.5.h,
                backgroundColor: isPast ? Colors.white24 : AppColors.kGold.withOpacity(0.1),
                child: Icon(
                  Icons.videocam_rounded,
                  color: isPast ? Colors.white30 : AppColors.kGold,
                  size: 3.h,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: participantName,
                      fontSize: 16.sp,
                      weight: FontWeight.bold,
                      color: isPast ? AppColors.kTextSecondary : AppColors.kTextPrimary,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: isPast ? Colors.white30 : AppColors.kGold),
                        SizedBox(width: 1.w),
                        CustomText(
                          title: "$formattedDate | $formattedTime",
                          fontSize: 12.sp,
                          color: isPast ? AppColors.kTextSecondary : AppColors.kGold,
                        ),
                      ],
                    ),
                    if (isPast) ...[
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CustomText(
                          title: "EXPIRED",
                          fontSize: 10.sp,
                          color: Colors.redAccent,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isPast)
                IconButton(
                  icon: const Icon(Icons.call_rounded, color: AppColors.kEmerald, size: 30),
                  onPressed: () => _handleJoinCall(item, isLawyer),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_camera_back_outlined, size: 70, color: AppColors.kTextSecondary.withOpacity(0.4)),
              SizedBox(height: 2.h),
              CustomText(
                title: message,
                fontSize: 15.sp,
                color: AppColors.kTextSecondary,
                alignText: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initiateCallFlow(String participantName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: CustomText(
          title: "Start Video Appointment",
          fontSize: 18.sp,
          weight: FontWeight.bold,
          color: AppColors.kTextPrimary,
        ),
        content: CustomText(
          title: "Calling $participantName... This will send a WhatsApp-style full-screen call page. (Simulating local ringing in 2 seconds!)",
          fontSize: 14.sp,
          color: AppColors.kTextSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Trigger CallKit incoming call UI mock locally after 1.5 seconds delay
              Future.delayed(const Duration(milliseconds: 1500), () {
                final uuid = const Uuid().v4();
                CallKitService().showIncomingCall(
                  uuid: uuid,
                  callerName: participantName,
                  callerAvatar: '',
                  channelName: AppKeys.channelName,
                  tempToken: AppKeys.agoraToken,
                );
              });
            },
            child: const Text('Call Now', style: TextStyle(color: AppColors.kEmerald, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
              SizedBox(height: 2.h),
              CustomText(
                title: error,
                fontSize: 15.sp,
                color: AppColors.kTextSecondary,
                alignText: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
