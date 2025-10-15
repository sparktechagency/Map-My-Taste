import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
   ForgotPasswordScreen({super.key});
  final TextEditingController forgotEmailCTRL = TextEditingController();

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
                text: AppStrings.addEmailAddress.tr,
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                bottom: 16.h,
              ),
              CustomText(
                text: AppStrings.weWillSendAnOTP.tr,
                maxLine: 5,
                textAlign: TextAlign.start,
                color: AppColors.greyColor,
                bottom: 16.h,
              ),
              //============================> Email Controller <===================================
              CustomTextField(
                controller: forgotEmailCTRL,
                labelText: AppStrings.emailAddress.tr,
              ),
              SizedBox(height: 301.h),
              //============================> Register Button <===================================
              CustomButton(onTap: () {}, text: AppStrings.sendMeTheCode.tr),
              SizedBox(height: 24.h)
            ],
          ),
        ),
      ),

    );
  }
}
