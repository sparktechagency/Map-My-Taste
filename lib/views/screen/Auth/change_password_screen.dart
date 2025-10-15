import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final TextEditingController oldPassCTRL = TextEditingController();
  final TextEditingController changeNewPassCTRL = TextEditingController();
  final TextEditingController confirmPassCTRL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: AppStrings.changePassword.tr,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                bottom: 16.h,
              ),
              CustomText(
                text: AppStrings.yourPasswordMust.tr,
                maxLine: 5,
                textAlign: TextAlign.start,
                color: AppColors.greyColor,
                bottom: 16.h,
              ),
              //============================> Current Password Controller <===================================
              CustomTextField(
                controller: oldPassCTRL,
                labelText: AppStrings.currentPassword.tr,
              ),
              SizedBox(height: 16.h),
              //============================> New Password Controller <===================================
              CustomTextField(
                controller: changeNewPassCTRL,
                labelText: AppStrings.newPassword.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Retype New Password Controller <===================================
              CustomTextField(
                controller: confirmPassCTRL,
                labelText: AppStrings.retypeNewPassword.tr,
              ),
              SizedBox(height: 180.h),
              CustomButton(onTap: () {}, text: AppStrings.changePassword.tr),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
