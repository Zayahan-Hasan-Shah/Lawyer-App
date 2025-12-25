import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/incoming_user_data/incoming_user_data.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: isLandscape ? 18.h : 14.h,
                    width: isLandscape ? 35.w : 45.w,
                    child: Image.asset(
                      AppAssets.logoImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLandscape ? 3 : 2,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 3.h,
                      childAspectRatio: isLandscape ? 1.1 : 0.8,
                    ),
                    itemCount: incomingUserData.length,
                    itemBuilder: (context, index) {
                      final info = incomingUserData[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: IncomingUserCard(
                          onTap: info["onTap"],
                          icon: info["icon"],
                          title: info["title"],
                          description: info["description"],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
