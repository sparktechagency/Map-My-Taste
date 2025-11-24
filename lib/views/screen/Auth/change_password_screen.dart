import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final AuthController _controller = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
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
                  controller: _controller.oldPasswordCtrl,
                  labelText: AppStrings.currentPassword.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //============================> New Password Controller <===================================
                CustomTextField(
                  controller: _controller.newPasswordCtrl,
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
                  controller: _controller.confirmPassController,
                  labelText: AppStrings.retypeNewPassword.tr,
                  validator: (value) {
                    if (value == null) {
                      return "Please re-enter new password";
                    } else if (value != _controller.newPasswordCtrl.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 180.h),
                //==========================> Update Password Button <=======================
                Obx(() => CustomButton(
                    loading: _controller.changePassLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.handleChangePassword(
                          _controller.oldPasswordCtrl.text,
                          _controller.newPasswordCtrl.text,
                        );
                      }
                    },
                    text: AppStrings.changePassword.tr,
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
