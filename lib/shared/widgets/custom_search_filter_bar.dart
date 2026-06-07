import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomSearchFilterBar extends StatefulWidget {
  final String hintText;
  final String? initialSearchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onDateTap;
  final Map<String, VoidCallback>? activeFilters;
  final EdgeInsetsGeometry? padding;

  const CustomSearchFilterBar({
    super.key,
    required this.hintText,
    this.initialSearchQuery,
    required this.onSearchChanged,
    this.onSearchSubmitted,
    this.onFilterTap,
    this.onDateTap,
    this.activeFilters,
    this.padding,
  });

  @override
  State<CustomSearchFilterBar> createState() => _CustomSearchFilterBarState();
}

class _CustomSearchFilterBarState extends State<CustomSearchFilterBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSearchQuery);
  }

  @override
  void didUpdateWidget(covariant CustomSearchFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearchQuery != oldWidget.initialSearchQuery &&
        widget.initialSearchQuery != _controller.text) {
      _controller.text = widget.initialSearchQuery ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = widget.activeFilters != null && widget.activeFilters!.isNotEmpty;

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.kSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: widget.onSearchChanged,
                    onSubmitted: (v) {
                      if (widget.onSearchSubmitted != null) {
                        widget.onSearchSubmitted!(v);
                      } else {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 13.sp,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.kGold,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              if (widget.onFilterTap != null) ...[
                SizedBox(width: 3.w),
                _buildFilterIcon(
                  Icons.filter_list_rounded,
                  widget.onFilterTap!,
                ),
              ],
              if (widget.onDateTap != null) ...[
                SizedBox(width: 3.w),
                _buildFilterIcon(
                  Icons.date_range_rounded,
                  widget.onDateTap!,
                ),
              ],
            ],
          ),
          if (hasActiveFilters)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Row(
                children: widget.activeFilters!.entries.map((entry) {
                  return _buildActiveFilterChip(entry.key, entry.value);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        width: 6.h,
        decoration: BoxDecoration(
          color: AppColors.kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
        ),
        child: Icon(icon, color: AppColors.kGold),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.kGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kGold.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            title: label,
            fontSize: 11.sp,
            color: AppColors.kGold,
            weight: FontWeight.w600,
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.kGold,
            ),
          ),
        ],
      ),
    );
  }
}
