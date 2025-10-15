import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final TextEditingController newPassCTRL = TextEditingController();
  final TextEditingController retypePassCTRL = TextEditingController();

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
                text: AppStrings.confirmYourNumber.tr,
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
              //============================> New Password Controller <===================================
              CustomTextField(
                controller: newPassCTRL,
                labelText: AppStrings.newPassword.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Retype New Password Controller <===================================
              CustomTextField(
                controller: retypePassCTRL,
                labelText: AppStrings.retypeNewPassword.tr,
              ),
              SizedBox(height: 209.h),
              //============================> Confirm Button <===================================
              CustomButton(onTap: () {}, text: AppStrings.confirm),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
