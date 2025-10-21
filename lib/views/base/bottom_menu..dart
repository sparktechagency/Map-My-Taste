import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../helpers/route.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_icons.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;

  const BottomMenu(this.menuIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "icon": AppIcons.home ?? 'assets/icons/default_home.svg',
        "route": AppRoutes.homeScreen,
      },
      {
        "icon": AppIcons.search ?? 'assets/icons/default_home.svg',
        "route": AppRoutes.profileScreen,
      },
      {
        "icon": AppIcons.love ?? 'assets/icons/default_home.svg',
        "route": AppRoutes.favoritesScreen,
      },
      {
        "icon": AppIcons.explore ?? 'assets/icons/default_home.svg',
        "route": AppRoutes.profileScreen,
      },
      {
        "icon": AppIcons.profile ?? 'assets/icons/default_profile.svg',
        "route": AppRoutes.profileScreen,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.only(left:  16.w, right: 16.w, bottom: 24.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreyColor,
        borderRadius: BorderRadius.circular(26.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isSelected = index == menuIndex;
          final item = items[index];
          return GestureDetector(
            onTap: () => Get.offAndToNamed(item["route"] as String),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Active item has a rounded container and shadow
                if (isSelected)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.3),
                     border: Border.all(width: 1.w, color: AppColors.primaryColor),
                     borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          item["icon"]!,
                          height: 28.w,
                          width: 28.w,
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                // Inactive item just displays the icon and label
                if (!isSelected)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        item["icon"]!,
                        height: 28.w,
                        width: 28.w,
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
