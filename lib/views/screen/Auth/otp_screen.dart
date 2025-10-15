import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_pin_code_text_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                text: AppStrings.enterTheCode.tr,
                maxLine: 5,
                textAlign: TextAlign.start,
                color: AppColors.greyColor,
                bottom: 16.h,
              ),
              //============================> Pin Code Field  <===================================
              CustomPinCodeTextField(),
              SizedBox(height: 24.h),
              //============================> Send Code Again Button <===================================
              Center(
                child: InkWell(
                  onTap: () {},
                  child: CustomText(
                    text: AppStrings.sendCodeAgain.tr,
                    fontSize: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 239.h),
              //============================> Confirm Button <===================================
              CustomButton(onTap: () {Get.toNamed(AppRoutes.resetPasswordScreen);}, text: AppStrings.confirm),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
