import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final AuthController _controller = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPassCTRL = TextEditingController();
  final TextEditingController retypePassCTRL = TextEditingController();

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
                  isPassword: true,
                  controller: newPassCTRL,
                  labelText: AppStrings.newPassword.tr,
                  validator: (value) {
                    if (value == null) {
                      return "Please set new password";
                    } else if (value.length < 8 || !_validatePassword(value)) {
                      return "Password: 8 characters min, letters & digits \nrequired";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //============================> Retype New Password Controller <===================================
                CustomTextField(
                  isPassword: true,
                  controller: retypePassCTRL,
                  labelText: AppStrings.retypeNewPassword.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter confirm password".tr;
                    } else if (newPassCTRL.text != retypePassCTRL.text) {
                      return "Password doesn't match".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 209.h),
                //============================> Confirm Button <===================================
                Obx(
                  () => CustomButton(
                    loading: _controller.resetPasswordLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.resetPassword(
                          newPassCTRL.text,
                          retypePassCTRL.text,
                        );
                      }
                    },
                    text: AppStrings.confirm.tr,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePassword(String value) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');
    return regex.hasMatch(value);
  }
}
