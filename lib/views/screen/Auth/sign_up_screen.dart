import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/controllers/auth_controller.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/views/base/custom_app_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
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
                  text: AppStrings.createYourAccount.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  bottom: 8.h,
                ),
                CustomText(
                  text: AppStrings.letGetYouSetUp.tr,
                  maxLine: 5,
                  textAlign: TextAlign.start,
                  color: AppColors.greyColor,
                  bottom: 8.h,
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
                  controller: _authController.signUpNameCTRL,
                  labelText: AppStrings.fullName.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //============================> Email Controller <===================================
                CustomTextField(
                  controller: _authController.signUpEmailCTRL,
                  labelText: AppStrings.email.tr,
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
                SizedBox(height: 16.h),
                //============================> Phone Number Controller <===================================
                CustomTextField(
                  controller: _authController.signUpPhoneNumberCTRL,
                  keyboardType: TextInputType.number,
                  labelText: AppStrings.phoneNumber.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //============================> Address Controller <===================================
                CustomTextField(
                  controller: _authController.signUpAddressCTRL,
                  labelText: AppStrings.address.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your address".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //=============================> Gender Selection <==============================
                CustomText(
                  text: AppStrings.gender.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                _genderRadioButton(),
                SizedBox(height: 8.h),
                //============================> Security Information <===================================
                CustomText(
                  text: AppStrings.security.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  bottom: 8.h,
                ),
                //============================> password Controller <===================================
                CustomTextField(
                  controller: _authController.signUpPassCTRL,
                  labelText: AppStrings.password.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //============================> Confirm password Controller <===================================
                CustomTextField(
                  controller: _authController.signUpConfirmPassCTRL,
                  labelText: AppStrings.confirmYourPassword.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter confirm password".tr;
                    }
                    else if(_authController.signUpPassCTRL.text != _authController.signUpConfirmPassCTRL.text){
                      return "Password doesn't match".tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),
                //============================> Check box Section <===================================
                _checkboxSection(),
                SizedBox(height: 8.h),
                //============================> Register Button <===================================
                Obx(()=> CustomButton(
                  loading: _authController.signUpLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (_authController.isChecked ) {
                        _authController.signUp();
                      }
                      else {
                        Fluttertoast.showToast(
                            msg: 'Please accept Terms & Conditions'.tr);
                      }
                    }
                  },
                  text: AppStrings.register.tr,
                ),
                ),
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
      ),
    );
  }

  //=========================> Gender Radio Button <================
  _genderRadioButton() {
    return Row(
      children: [
        InkWell(
          onTap:
              () => setState(() {
                _authController.selectedGender = 'male';
          }),
          child: Row(
            children: [
              Radio<String>(
                value: 'male',
                groupValue: _authController.selectedGender,
                onChanged: (value) {
                  setState(() {
                    _authController.selectedGender = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.primaryColor;
                  }
                  return AppColors.primaryColor;
                }),
              ),
              CustomText(text: 'Male'.tr, fontSize: 14.sp),
            ],
          ),
        ),
        InkWell(
          onTap:
              () => setState(() {
                _authController.selectedGender = 'female';
          }),
          child: Row(
            children: [
              Radio<String>(
                value: 'female',
                groupValue: _authController.selectedGender,
                onChanged: (value) {
                  setState(() {
                    _authController.selectedGender = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.primaryColor;
                  }
                  return AppColors.primaryColor;
                }),
              ),
              CustomText(text: 'Female'.tr, fontSize: 14.sp),
            ],
          ),
        ),
        InkWell(
          onTap:
              () => setState(() {
                _authController.selectedGender = 'other';
          }),
          child: Row(
            children: [
              Radio<String>(
                value: 'other',
                groupValue: _authController.selectedGender,
                onChanged: (value) {
                  setState(() {
                    _authController.selectedGender = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return AppColors.primaryColor;
                  }
                  return AppColors.primaryColor;
                }),
              ),
              CustomText(text: 'Other'.tr, fontSize: 14.sp),
            ],
          ),
        ),
      ],
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
           value: _authController.isChecked,
           onChanged: (bool? value) {
             setState(() {
               _authController.isChecked = value ?? false;
             });
           },
           side: BorderSide(
             color: _authController.isChecked ? AppColors.primaryColor : AppColors.primaryColor,
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
                     Get.toNamed(AppRoutes.termsPoliciesScreen);
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
                     Get.toNamed(AppRoutes.termsPoliciesScreen);
                   },
               ),
             ],
           ),
         ),
       ],
     );
   }
}
