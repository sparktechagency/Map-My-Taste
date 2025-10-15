import 'package:flutter/gestures.dart';
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

class SignUpScreen extends StatefulWidget {
   SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController signUpNameCTRL = TextEditingController();
  final TextEditingController signUpEmailCTRL = TextEditingController();
  final TextEditingController signUpPhoneNumberCTRL = TextEditingController();
  final TextEditingController signUpAddressCTRL = TextEditingController();
  final TextEditingController signUpGenderCTRL = TextEditingController();
  final TextEditingController signUpPassCTRL = TextEditingController();
  final TextEditingController signUpConfirmPassCTRL = TextEditingController();
   bool isChecked = false;

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
                bottom: 16.h,
              ),
              //============================> Personal Information <===================================
              CustomText(
                text: AppStrings.personalInformation.tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                bottom: 8.h,
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
              SizedBox(height: 16.h),
              //============================> Security Information <===================================
              CustomText(
                text: AppStrings.security.tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                bottom: 8.h,
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
              SizedBox(height: 16.h),
              //============================> Check box Section <===================================
              _checkboxSection(),
              SizedBox(height: 16.h),
              //============================> Register Button <===================================
              CustomButton(onTap: () {}, text: AppStrings.register.tr),
              SizedBox(height: 8.h),
              //============================> Already have register yet? Register Row <===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: AppStrings.alreadyHaveAnAccount.tr,
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

   //==========================> Checkbox Section Widget <=======================
   _checkboxSection() {
     return Row(
       children: [
         Checkbox(
           checkColor: Colors.white,
           activeColor: AppColors.primaryColor,
           focusColor: AppColors.greyColor,
           value: isChecked,
           onChanged: (bool? value) {
             setState(() {
               isChecked = value ?? false;
             });
           },
           side: BorderSide(
             color: isChecked ? AppColors.primaryColor : AppColors.primaryColor,
             width: 1.w,
           ),
         ),
         Text.rich(
           maxLines: 2,
           TextSpan(
             text: 'By creating an account, I accept the\n ',
             style: TextStyle(fontSize: 14.w, fontWeight: FontWeight.w500),
             children: [
               TextSpan(
                 text: 'Terms & Conditions',
                 style: TextStyle(
                     color: AppColors.primaryColor,
                     fontSize: 14.w,
                     fontWeight: FontWeight.w500),
                 recognizer: TapGestureRecognizer()
                   ..onTap = () {
                     //Get.toNamed(AppRoutes.termsConditionScreen);
                   },
               ),
               const TextSpan(text: ' & '),
               TextSpan(
                 text: 'Privacy Policy.',
                 style: TextStyle(
                     color: AppColors.primaryColor,
                     fontSize: 14.w,
                     fontWeight: FontWeight.w500),
                 recognizer: TapGestureRecognizer()
                   ..onTap = () {
                     //Get.toNamed(AppRoutes.privacyPolicyScreen);
                   },
               ),
             ],
           ),
         ),
       ],
     );
   }
}
