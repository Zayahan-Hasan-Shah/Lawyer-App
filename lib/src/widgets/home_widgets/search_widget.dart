// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lawyer_app/src/core/constants/app_colors.dart';
// import 'package:lawyer_app/src/providers/home_screen_provider/search_provider.dart';
// import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
// import 'package:sizer/sizer.dart';

// class SearchWidget extends ConsumerStatefulWidget {
//   const SearchWidget({super.key});

//   @override
//   ConsumerState<SearchWidget> createState() => _SearchWidgetState();
// }

// class _SearchWidgetState extends ConsumerState<SearchWidget> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final searchQueryNotifier = ref.watch(searchQueryProvider.notifier);

//     return Padding(
//       padding: EdgeInsetsGeometry.symmetric(horizontal: 2.h),
//       child: CustomTextField(
//         controller: _controller,
//         hintText: "Search by lawyer type or location",
//         textColor: AppColors.whiteColor,
//         hintTextColor: AppColors.hintTextColor,
//         suffixIcon: Icon(Icons.search, color: AppColors.iconColor, size: 20),
//         onChanged: (value) {
//           searchQueryNotifier.state = value.trim();
//         },
//       ),
//     );
//   }
// }
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/client_provider/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final String hintText;
  final bool useSearchProvider;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? backgroundColor;
  final TextEditingController? controller;

  const SearchWidget({
    super.key,
    this.hintText = "Search lawyers, cases...",
    this.useSearchProvider = true,
    this.onChanged,
    this.prefixIcon,
    this.textColor,
    this.hintTextColor,
    this.backgroundColor,
    this.controller,
  });

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQueryNotifier = widget.useSearchProvider
        ? ref.read(searchQueryProvider.notifier)
        : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: CustomTextField(
            controller: _controller,
            hintText: widget.hintText,
            textColor: widget.textColor ?? AppColors.kTextPrimary,
            hintTextColor: widget.hintTextColor ?? AppColors.kTextSecondary,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Icon(
                widget.prefixIcon ?? Icons.search_rounded,
                color: AppColors.kEmerald,
                size: 26,
              ),
            ),
            fillColor:
                widget.backgroundColor ?? AppColors.kSurface.withOpacity(0.85),
            onChanged: (value) {
              final trimmed = value.trim();
              if (widget.useSearchProvider) {
                searchQueryNotifier?.state = trimmed;
              }
              widget.onChanged?.call(trimmed);
            },
            borderRadius: 20,
          ),
        ),
      ),
    );
  }
}
