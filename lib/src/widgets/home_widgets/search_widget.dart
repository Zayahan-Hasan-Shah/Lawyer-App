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


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

/// A reusable search bar widget.
///
/// Can be used across the app (home, lawyer list, search screens, etc.)
/// Supports Riverpod integration or custom onChanged callbacks.
class SearchWidget extends ConsumerStatefulWidget {
  /// Placeholder text inside the search bar
  final String hintText;

  /// Optional: Whether to use Riverpod search provider
  final bool useSearchProvider;

  /// Optional: Custom onChanged callback (for manual handling)
  final ValueChanged<String>? onChanged;

  /// Optional: Leading icon (defaults to search)
  final IconData? prefixIcon;

  /// Optional: Text color for input
  final Color? textColor;

  /// Optional: Hint text color
  final Color? hintTextColor;

  /// Optional: Background color (if you want to override)
  final Color? backgroundColor;

  /// Optional: Controller (if external state management is needed)
  final TextEditingController? controller;

  const SearchWidget({
    super.key,
    this.hintText = "Search...",
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
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only use provider if requested
    final searchQueryNotifier = widget.useSearchProvider
        ? ref.watch(searchQueryProvider.notifier)
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: CustomTextField(
        controller: _internalController,
        hintText: widget.hintText,
        textColor: widget.textColor ?? AppColors.whiteColor,
        hintTextColor: widget.hintTextColor ?? AppColors.hintTextColor,
        suffixIcon: Icon(
          widget.prefixIcon ?? Icons.search,
          color: AppColors.iconColor,
          size: 20,
        ),
        onChanged: (value) {
          if (widget.useSearchProvider) {
            searchQueryNotifier!.state = value.trim();
          }
          if (widget.onChanged != null) {
            widget.onChanged!(value.trim());
          }
        },
      ),
    );
  }
}
