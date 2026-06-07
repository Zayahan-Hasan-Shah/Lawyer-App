import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';

class DatePickerHelper {
  static Future<DateTimeRange?> showGenericDateRangePicker(
    BuildContext context, {
    DateTime? firstDate,
    DateTime? lastDate,
    DateTimeRange? initialDateRange,
  }) async {
    return await showDateRangePicker(
      context: context,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      initialDateRange: initialDateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.kGold,
            onPrimary: Colors.black,
            surface: AppColors.kSurface,
          ),
        ),
        child: child!,
      ),
    );
  }
}
