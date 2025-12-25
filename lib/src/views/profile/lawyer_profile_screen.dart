import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class LawyerProfileScreen extends StatelessWidget {
  final LawyerModel lawyer;

  const LawyerProfileScreen({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        isBack: true,
        title: '${lawyer.firstName} ${lawyer.lastName}',
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== FIXED IMAGE HEADER =====
          SizedBox(
            height: 45.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: lawyer.profilePhoto,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Container(color: AppColors.backgroundColor.withOpacity(0.3)),
              ],
            ),
          ),

          // ===== FIXED TOP ROW =====
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            child: _buildTopRow(),
          ),

          // ===== SCROLLABLE SECTION =====
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  _buildText(lawyer.category, 15.sp, Colors.white),
                  SizedBox(height: 2.h),
                  _buildSectionTitle('Biography'),
                  SizedBox(height: 0.5.h),
                  _buildDescription(
                    lawyer.biography.isNotEmpty
                        ? lawyer.biography
                        : 'No biography available.',
                  ),

                  SizedBox(height: 2.h),
                  _buildSectionTitle('Description'),
                  SizedBox(height: 0.5.h),
                  _buildDescription(
                    lawyer.description.isNotEmpty
                        ? lawyer.description
                        : 'No description available.',
                  ),

                  SizedBox(height: 3.h),
                  CustomButton(
                    text: 'Book Now',
                    onPressed: () {},
                    textColor: AppColors.blackColor,
                    gradient: AppColors.buttonGradientColor,
                    fontWeight: FontWeight.w600,
                    borderRadius: 30,
                    width: double.infinity,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildSectionTitle(String text) =>
      _buildText(text, 18.sp, Colors.white);

  Widget _buildDescription(String text) => CustomText(
    title: text,
    maxLines: 20,
    color: AppColors.hintTextColor,
    fontSize: 16.sp,
    alignText: TextAlign.justify,
  );

  Widget _buildText(String text, double fontSize, Color color) =>
      CustomText(title: text, fontSize: fontSize, color: color);

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side (name & practice)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(
              '${lawyer.firstName} ${lawyer.lastName}',
              18.sp,
              Colors.white,
            ),
            _buildText('Area of Practice', 14.sp, Colors.white70),
          ],
        ),
        // Right side (ratings)
        Row(
          children: [
            Icon(Icons.star, color: AppColors.iconColor, size: 18),
            SizedBox(width: 4),
            _buildText('${lawyer.rating}', 15.sp, Colors.white),
            _buildText(' (${lawyer.reviews})', 14.sp, Colors.white70),
          ],
        ),
      ],
    );
  }
}
