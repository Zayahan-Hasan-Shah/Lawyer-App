import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQueryNotifier = ref.watch(searchQueryProvider.notifier);

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.h),
      child: CustomTextField(
        controller: _controller,
        hintText: "Search by lawyer type or location",
        textColor: AppColors.whiteColor,
        hintTextColor: AppColors.hintTextColor,
        suffixIcon: Icon(Icons.search, color: AppColors.iconColor, size: 20),
        onChanged: (value) {
          searchQueryNotifier.state = value.trim();
        },
      ),
    );
  }
}
