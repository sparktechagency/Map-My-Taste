import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
   ForgotPasswordScreen({super.key});
   final AuthController _authController = Get.put(AuthController());
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
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
                  controller: _authController.forgetEmailTextCtrl,
                  labelText: AppStrings.emailAddress.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email".tr;
                    }
                    if (!AppConstants.emailValidator.hasMatch(value)) {
                      return "Please enter a valid email".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 301.h),
                //============================> Register Button <===================================
                Obx(() => CustomButton(
                    loading: _authController.forgotLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _authController.forgetPassword();
                      }
                    },
                    text: AppStrings.sendMeTheCode.tr,
                  ),
                ),
                SizedBox(height: 24.h)
              ],
            ),
          ),
        ),
      ),

    );
  }
}
