import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_network_image.dart';
import '../../base/custom_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        titleSpacing: 0.w,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Flexible(
          child: CustomText(
            text: AppStrings.notification.tr,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          _popupMenuButton(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 25,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomNetworkImage(
                              imageUrl:
                              'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                              height: 56.h,
                              width: 56.w,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Motin mia',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.start,
                                    bottom: 8.h,
                                  ),
                                  CustomText(
                                    text: 'Commented on your review.',
                                    fontSize: 16.sp,
                                    color: AppColors.greyColor,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );
  }

  //==============================> Popup Menu Button <===================================

  PopupMenuButton<int> _popupMenuButton() {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      icon: SvgPicture.asset(AppIcons.dot, color: Colors.white),
      onSelected: (int result) {
        print(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.mute),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Mark all as read'.tr,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.delete),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Delete all'.tr,
              ),
            ],
          ),
        ),
      ],
      color: AppColors.fillColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
