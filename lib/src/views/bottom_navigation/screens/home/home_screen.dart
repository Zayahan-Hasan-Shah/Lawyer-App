import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/home_screen_data/home_screen_data.dart';
import 'package:lawyer_app/src/providers/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/home_widgets/home_screen_widget.dart';
import 'package:lawyer_app/src/widgets/home_widgets/search_widget.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredData = homeScreenData.where((item) {
      final type = item["laywer_type"].toString().toLowerCase();
      final location = item["location"].toString().toLowerCase();
      final query = searchQuery.toLowerCase();

      return type.contains(query) || location.contains(query);
    }).toList();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(isDrawwer: true, logoImage: AppAssets.logoImage),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 3.h),
            SearchWidget(),
            SizedBox(height: 1.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 1.h),
                child: TextButton(
                  onPressed: () {},
                  child: CustomText(
                    title: "View All",
                    color: Colors.white,
                    fontSize: 18.sp,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                alignment: Alignment.center,
                child: MasonryGridView.builder(
                  itemCount: filteredData.length,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                  itemBuilder: (context, index) {
                    final info = filteredData[index];
                    final height = (index.isEven) ? 24.h : 26.h;
                    return ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(8),
                      child: SizedBox(
                        height: height,
                        child: HomeScreenWidget(
                          image: info["image"],
                          pendingcaseCase: info["case"],
                          laywerType: info["laywer_type"],
                          address: info["location"],
                          onTap: info["onTap"],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
