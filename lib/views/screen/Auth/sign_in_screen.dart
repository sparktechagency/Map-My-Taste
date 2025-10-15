import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final TextEditingController emailCTRL = TextEditingController();
  final TextEditingController passCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 44.h),
              CustomText(
                text: AppStrings.welcomeBack.tr,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                bottom: 16.h,
              ),
              CustomText(
                text: AppStrings.pleaseLogIn.tr,
                maxLine: 5,
                textAlign: TextAlign.start,
                color: AppColors.greyColor,
                bottom: 56.h,
              ),
              //============================> Email Controller <===================================
              CustomTextField(
                controller: emailCTRL,
                labelText: AppStrings.email.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Password Controller <===================================
              CustomTextField(
                controller: passCTRL,
                labelText: AppStrings.password.tr,
              ),
              SizedBox(height: 16.h),
              //============================> Forgot Password Button <===================================
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {Get.toNamed(AppRoutes.forgotPasswordScreen);},
                  child: CustomText(
                    text: AppStrings.forgotPassword,
                    fontSize: 16.sp,
                    color: AppColors.greyColor,
                    textDecoration: TextDecoration.underline,
                    bottom: 40.h,
                  ),
                ),
              ),
              //============================> Log In Button <===================================
              CustomButton(onTap: () {}, text: AppStrings.logIn.tr),
              SizedBox(height: 48.h),
              //============================> Or Row <===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 116.w,
                    child: Divider(thickness: 0.4, color: Colors.grey),
                  ),
                  CustomText(text: AppStrings.or, color: AppColors.greyColor),
                  SizedBox(
                    width: 116.w,
                    child: Divider(thickness: 0.4, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 48.h),
              //============================> Log in with google <===================================
              Container(
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.google),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: AppStrings.loginWithApple.tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              //============================> Haven’t register yet? Register Row <===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: AppStrings.haveNotRegisterYet.tr,
                    fontSize: 16.sp,
                    right: 6.w,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.signUpScreen);
                    },
                    child: CustomText(
                      text: AppStrings.register.tr,
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
