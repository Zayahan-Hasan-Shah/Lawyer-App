import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentStep extends StatefulWidget {
  final String? appointmentType;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final ValueChanged<TimeOfDay?> onTimeChanged;
  final VoidCallback onConfirm;

  const AppointmentStep({
    super.key,
    required this.appointmentType,
    required this.selectedDate,
    required this.selectedTime,
    required this.onTypeChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onConfirm,
  });

  @override
  State<AppointmentStep> createState() => _AppointmentStepState();
}

class _AppointmentStepState extends State<AppointmentStep> {
  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.kEmerald,
              onPrimary: Colors.white,
              surface: AppColors.kSurface,
              onSurface: AppColors.kTextPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.kEmerald),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (picked.hour >= 8 && picked.hour < 17) {
        widget.onTimeChanged(picked);
      } else {
        _showSnackBar("Office hours are 8:00 AM – 5:00 PM");
      }
    }
  }

  Widget _appointmentCard(
    String title,
    IconData icon,
    String value, {
    bool isPaid = false,
  }) {
    final selected = widget.appointmentType == value;

    return GestureDetector(
      onTap: () {
        widget.onTypeChanged(value);
        if (value == "video") widget.onConfirm();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(4.5.w),
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.kEmerald.withOpacity(0.65)
                : AppColors.kEmerald.withOpacity(0.15),
            width: selected ? 2.2 : 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.kEmerald.withOpacity(0.38),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: selected
                    ? LinearGradient(
                        colors: [
                          AppColors.kEmerald.withOpacity(0.35),
                          AppColors.kEmeraldDark.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: selected ? null : AppColors.kEmerald.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: selected ? Colors.white : AppColors.kEmerald,
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    fontSize: 17.sp,
                    weight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected
                        ? AppColors.kEmerald
                        : AppColors.kTextPrimary,
                  ),
                  if (isPaid) ...[
                    SizedBox(height: 0.4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kEmerald.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Paid Consultation",
                        style: TextStyle(
                          color: AppColors.kEmerald,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.kEmerald,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "Choose Appointment Type",
          fontSize: 20.sp,
          weight: FontWeight.w700,
          color: AppColors.kTextPrimary,
        ),
        SizedBox(height: 0.8.h),
        CustomText(
          title: "Select how you'd like to meet with your lawyer",
          fontSize: 14.5.sp,
          color: AppColors.kTextSecondary,
        ),
        SizedBox(height: 4.h),

        // Video Appointment Card
        _appointmentCard(
          "Video Call Appointment",
          Icons.videocam_rounded,
          "video",
          isPaid: true,
        ),

        SizedBox(height: 3.h),

        // Walk-in Appointment Card
        _appointmentCard(
          "Walk-in Appointment",
          Icons.location_on_rounded,
          "walkin",
        ),

        if (widget.appointmentType == "walkin") ...[
          SizedBox(height: 4.h),

          // Calendar Section
          Container(
            decoration: BoxDecoration(
              color: AppColors.kSurface.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.kEmerald.withOpacity(0.18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.all(3.w),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 90)),
              focusedDay: widget.selectedDate ?? DateTime.now(),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              selectedDayPredicate: (day) =>
                  isSameDay(widget.selectedDate, day),
              enabledDayPredicate: (day) =>
                  day.weekday != DateTime.saturday &&
                  day.weekday != DateTime.sunday,
              onDaySelected: (selectedDay, focusedDay) {
                widget.onDateChanged(selectedDay);
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: AppColors.kTextPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.kEmerald,
                  size: 28,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.kEmerald,
                  size: 28,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.kEmerald.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.redAccent.withOpacity(0.8),
                ),
                disabledTextStyle: TextStyle(
                  color: AppColors.kTextSecondary.withOpacity(0.5),
                ),
                defaultTextStyle: TextStyle(color: AppColors.kTextPrimary),
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: AppColors.kTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: Colors.redAccent.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Time Picker
          if (widget.selectedDate != null)
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.kSurface.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.kEmerald.withOpacity(0.18),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding:  EdgeInsets.all(1.h),
                      decoration: BoxDecoration(
                        color: AppColors.kEmerald.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.access_time_rounded,
                        color: AppColors.kEmerald,
                        size: 3.h,
                      ),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "Select Preferred Time",
                            fontSize: 15.sp,
                            color: AppColors.kTextSecondary,
                          ),
                          SizedBox(height: 0.4.h),
                          CustomText(
                            title: widget.selectedTime == null
                                ? "8:00 AM – 5:00 PM"
                                : "Selected: ${widget.selectedTime!.format(context)}",
                            fontSize: 15.sp,
                            weight: FontWeight.w600,
                            color: widget.selectedTime == null
                                ? AppColors.kTextSecondary
                                : AppColors.kEmerald,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.kEmerald,
                      size: 3.h,
                    ),
                  ],
                ),
              ),
            ),

          if (widget.selectedDate != null && widget.selectedTime != null) ...[
            SizedBox(height: 2.5.h),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: CustomButton(
                text: "Confirm Appointment",
                onPressed: widget.onConfirm,
                gradient: LinearGradient(
                  colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                textColor: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                borderRadius: 16,

              ),
            ),
          ],
        ],
      ],
    );
  }
}
