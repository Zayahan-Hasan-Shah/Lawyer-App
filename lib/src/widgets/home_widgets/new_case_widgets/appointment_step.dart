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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      if (picked.hour >= 8 && picked.hour < 17) {
        widget.onTimeChanged(picked);
      } else {
        _showSnackBar("Please select time between 8:00 AM and 5:00 PM");
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
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.buttonGradientColor : null,
          color: selected ? null : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : AppColors.brightYellowColor.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.brightYellowColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.blackColor.withOpacity(0.1)
                    : AppColors.brightYellowColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: selected
                    ? AppColors.blackColor
                    : AppColors.brightYellowColor,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: CustomText(
                title: title,
                color: selected ? AppColors.blackColor : AppColors.whiteColor,
                fontSize: 16.sp,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appointmentCard(
          "Video Call Appointment",
          Icons.videocam,
          "video",
          isPaid: true,
        ),
        SizedBox(height: 3.h),
        _appointmentCard("Walk-in Appointment", Icons.location_on, "walkin"),
        if (widget.appointmentType == "walkin") ...[
          SizedBox(height: 3.h),
          Container(
            constraints: BoxConstraints(maxHeight: 45.h),
            decoration: BoxDecoration(
              color: AppColors.inputBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.brightYellowColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.all(4.w),
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
              onDaySelected: (d, _) => widget.onDateChanged(d),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: AppColors.brightYellowColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: AppColors.brightYellowColor,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  gradient: AppColors.buttonGradientColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.brightYellowColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.red[300]),
                disabledTextStyle: TextStyle(color: Colors.grey[700]),
                defaultTextStyle: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          if (widget.selectedDate != null)
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: AppColors.inputBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.brightYellowColor.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.brightYellowColor,
                      size: 24.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        title: widget.selectedTime == null
                            ? "Select Time (8:00 AM - 5:00 PM)"
                            : "Selected: ${widget.selectedTime!.format(context)}",
                        color: AppColors.whiteColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.brightYellowColor,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ),
          if (widget.selectedDate != null && widget.selectedTime != null) ...[
            SizedBox(height: 3.h),
            CustomButton(
              text: "Confirm Appointment",
              onPressed: widget.onConfirm,
              gradient: AppColors.buttonGradientColor,
              textColor: AppColors.blackColor,
              fontSize: 18.sp,
            ),
          ],
        ],
      ],
    );
  }
}
