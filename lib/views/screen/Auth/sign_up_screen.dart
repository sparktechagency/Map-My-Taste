import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/views/base/custom_app_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});
  final TextEditingController signUpNameCTRL = TextEditingController();
  final TextEditingController signUpEmailCTRL = TextEditingController();
  final TextEditingController signUpPhoneNumberCTRL = TextEditingController();
  final TextEditingController signUpAddressCTRL = TextEditingController();
  final TextEditingController signUpGenderCTRL = TextEditingController();
  final TextEditingController signUpPassCTRL = TextEditingController();
  final TextEditingController signUpConfirmPassCTRL = TextEditingController();

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
                text: AppStrings.createYourAccount.tr,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                bottom: 16.h,
              ),
              CustomText(
                text: AppStrings.letGetYouSetUp.tr,
                maxLine: 5,
                textAlign: TextAlign.start,
                color: AppColors.greyColor,
                bottom: 32.h,
              ),
              //============================> Personal Information <===================================
              CustomText(
                text: AppStrings.personalInformation.tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                bottom: 16.h,
              ),
              //============================> Name Controller <===================================
              CustomTextField(
                controller: signUpNameCTRL,
                labelText: AppStrings.fullName.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Phone Number Controller <===================================
              CustomTextField(
                controller: signUpPhoneNumberCTRL,
                labelText: AppStrings.password.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Address Controller <===================================
              CustomTextField(
                controller: signUpAddressCTRL,
                labelText: AppStrings.address.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Gender Controller <===================================
              CustomTextField(
                controller: signUpGenderCTRL,
                labelText: AppStrings.gender.tr,
              ),
              SizedBox(height: 32.h),
              //============================> Security Information <===================================
              CustomText(
                text: AppStrings.security.tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                bottom: 16.h,
              ),
              //============================> password Controller <===================================
              CustomTextField(
                controller: signUpPassCTRL,
                labelText: AppStrings.password.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Confirm password Controller <===================================
              CustomTextField(
                controller: signUpConfirmPassCTRL,
                labelText: AppStrings.confirmYourPassword.tr,
              ),
              SizedBox(height: 24.h),

              //============================> Log In Button <===================================
              CustomButton(onTap: () {}, text: AppStrings.logIn.tr),
              SizedBox(height: 24.h),
              //============================> Already have register yet? Register Row <===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Already have an account'.tr,
                    fontSize: 16.sp,
                    right: 6.w,
                  ),
                  InkWell(
                    onTap: () {Get.toNamed(AppRoutes.signInScreen);},
                    child: CustomText(
                      text: AppStrings.logIn.tr,
                      color: AppColors.primaryColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
