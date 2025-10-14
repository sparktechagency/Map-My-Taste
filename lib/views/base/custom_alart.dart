/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_template/views/base/custom_button.dart';
import 'package:project_template/views/base/custom_text.dart';
import '../../../../../../helpers/route.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../../helpers/prefs_helpers.dart';
import '../../utils/app_constants.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 24.h),
            CustomText(
              text: 'Success',
              fontSize: 16.sp,
              maxLine: 2,
            ),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                width: 120.w,
                height: 40.h,
                text: 'No',
                onTap: () {
                  Get.back();
                },
                color: Colors.white,
                textStyle: TextStyle(color: AppColors.primaryColor),
              ),
              SizedBox(width: 12.w),
              CustomButton(
                  width: 120.w,
                  height: 40.h,
                  text: 'Yes',
                  textColor: Colors.white,
                  onTap: () async {
                    await PrefsHelper.remove(AppConstants.isLogged);
                    await PrefsHelper.remove(AppConstants.id);
                    await PrefsHelper.remove(AppConstants.bearerToken);
                    //   await PrefsHelper.remove(AppConstants.subscription);
                    Get.offAllNamed(AppRoutes.splashScreen);
                  })
            ],
          ),
        ],
        elevation: 12.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(width: 1.w, color: AppColors.primaryColor)));
  }
}
*/
