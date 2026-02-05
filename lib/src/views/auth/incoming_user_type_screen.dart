import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/incoming_user_data/incoming_user_data.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/incoming_user_widgets/incoming_user_card.dart';
import 'package:sizer/sizer.dart';

class IncomingUserTypeScreen extends StatefulWidget {
  const IncomingUserTypeScreen({super.key});

  @override
  State<IncomingUserTypeScreen> createState() => _IncomingUserTypeScreenState();
}

class _IncomingUserTypeScreenState extends State<IncomingUserTypeScreen> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 8.w : 6.w,
              vertical: 4.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with subtle lift
                Container(
                  height: isLandscape ? 20.h : 16.h,
                  width: isLandscape ? 38.w : 48.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kEmerald.withOpacity(0.15),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(AppAssets.logoImage, fit: BoxFit.contain),
                ),

                SizedBox(height: isLandscape ? 1.5.h : 2.h),

                // Optional elegant title
                CustomText(
                  title:"Choose Your Role",
                    color: AppColors.kTextPrimary,
                    fontSize: 24.sp,
                    weight: FontWeight.w800,
                    letterSpacing: 1.2,
                ),

                SizedBox(height: 0.5.h),

                CustomText(
                  title: "Get started in seconds",
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                ),

                SizedBox(height: isLandscape ? 2.5.h : 3.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: isLandscape ? 3.w : 4.w,
                    mainAxisSpacing: 4.h,
                    childAspectRatio: isLandscape ? 1.15 : 0.9 ,
                  ),
                  itemCount: incomingUserData.length,
                  itemBuilder: (context, index) {
                    final info = incomingUserData[index];
                    return IncomingUserCard(
                      onTap: info["onTap"],
                      icon: info["icon"],
                      title: info["title"],
                      description: info["description"],
                    );
                  },
                ),

                // SizedBox(height: 6.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
