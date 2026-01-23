// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sizer/sizer.dart';

// class IncomingUserCard extends ConsumerWidget {
//   final void Function(WidgetRef ref, BuildContext context) onTap;
//   final IconData icon;
//   final String title;
//   final String description;

//   const IncomingUserCard({
//     super.key,
//     required this.onTap,
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//       onTap: () => onTap(ref, context),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           gradient: LinearGradient(
//             colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.yellowAccent.withOpacity(0.2),
//               blurRadius: 20,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, color: Colors.yellowAccent, size: 8.h),
//                   SizedBox(height: 2.h),
//                   Text(
//                     title,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.yellowAccent,
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                   SizedBox(height: 1.h),
//                   Text(
//                     description,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.85),
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lawyer_app/src/core/constants/app_colors.dart';
// import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
// import 'package:sizer/sizer.dart';

// class IncomingUserCard extends ConsumerWidget {
//   final void Function(WidgetRef ref, BuildContext context) onTap;
//   final IconData icon;
//   final String title;
//   final String description;

//   const IncomingUserCard({
//     super.key,
//     required this.onTap,
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return GestureDetector(
//       onTap: () => onTap(ref, context),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 280),
//         curve: Curves.easeOutCubic,
//         decoration: BoxDecoration(
//           color: AppColors.kSurface,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(
//             color: AppColors.kEmerald.withOpacity(0.18),
//             width: 1.2,
//           ),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(24),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     AppColors.kSurface.withOpacity(0.92),
//                     AppColors.kSurfaceElevated.withOpacity(0.75),
//                   ],
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 2.5.h, // ← increased a bit for breathing room
//                   horizontal: 3.w,
//                 ),
//                 child: Column(
//                   mainAxisSize:
//                       MainAxisSize.min, // ← important: don't force max size
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Icon section - fixed size
//                     Container(
//                       padding: EdgeInsets.all(2.h),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             AppColors.kEmerald.withOpacity(0.25),
//                             AppColors.kEmeraldDark.withOpacity(0.08),
//                           ],
//                         ),
//                       ),
//                       child: Icon(icon, color: AppColors.kEmerald, size: 8.h),
//                     ),

//                     Flexible(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           CustomText(
//                             title: title,
//                             alignText: TextAlign.center,
//                             fontSize: 18.sp, // ← slightly smaller is safer
//                             weight: FontWeight.w700,
//                             maxLines: 2,
//                           ),
//                           CustomText(
//                             title: description,
//                             alignText: TextAlign.center,
//                             fontSize: 14.sp,
//                             maxLines: 2, // ← increased to 3 lines
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class IncomingUserCard extends ConsumerWidget {
  final void Function(WidgetRef ref, BuildContext context) onTap;
  final IconData icon;
  final String title;
  final String description;

  const IncomingUserCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onTap(ref, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: AppColors.kSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.kEmerald.withOpacity(0.18),
            width: 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.kSurface.withOpacity(0.92),
                    AppColors.kSurfaceElevated.withOpacity(0.75),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 1.5.h, // ← reduced from 2.5.h
                  horizontal: 2.5.w, // ← reduced from 3.w
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon section - made more compact
                    Container(
                      padding: EdgeInsets.all(1.2.h), // ← reduced from 2.h
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.kEmerald.withOpacity(0.25),
                            AppColors.kEmeraldDark.withOpacity(0.08),
                          ],
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.kEmerald,
                        size: 6.h,
                      ), // ← reduced from 8.h
                    ),
                    SizedBox(height: 1.h),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            title: title,
                            alignText: TextAlign.center,
                            fontSize: 18.sp, // ← reduced from 18.sp
                            weight: FontWeight.w700,
                            color: AppColors.kTextPrimary,
                          ),
                          SizedBox(height: 0.2.h),
                          CustomText(
                            title: description,
                            alignText: TextAlign.center,
                            fontSize: 16.sp, // ← reduced from 14.sp
                            maxLines: 2,
                            color: AppColors.kTextSecondary,
                            textHeight: 1.2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
