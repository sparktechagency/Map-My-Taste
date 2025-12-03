import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_pin_code_text_field.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_text.dart';

class ForgotOtpScreen extends StatefulWidget {
  const ForgotOtpScreen({super.key});

  @override
  State<ForgotOtpScreen> createState() => _ForgotOtpScreenState();
}

class _ForgotOtpScreenState extends State<ForgotOtpScreen> {
  late final AuthController _authController;
  final TextEditingController _otpController = TextEditingController();
  var parameters = Get.parameters;

  @override
  void initState() {
    super.initState();
    startTimer();
    if (Get.arguments != null && Get.arguments['isPassreset'] != null) {
      getResetPass();
    }
    // Only put the controller if it's not already registered to avoid multiple instances
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    _authController = Get.find();
  }

  int _start = 180;
  Timer _timer = Timer(const Duration(seconds: 1), () {});

  startTimer() {
    print("Start Time$_start");
    print("Start Time$_timer");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool isResetPassword = false;

  getResetPass() {
    var isResetPass = Get.arguments['isPassreset'];
    if (isResetPass) {
      isResetPassword = isResetPass;
    }
  }

  void resetTimer() {
    _start = 180;
    startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer.cancel();
    super.dispose();
  }


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
              CustomPinCodeTextField(
                textEditingController: _authController.otpCtrlForgot,
              ),
              SizedBox(height: 24.h),
              //========================> Timer Field <==================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.clock,color: AppColors.primaryColor,),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: '$timerText sc',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              //============================> Send Code Again Button <===================================
              Center(
                child: InkWell(
                  onTap: _start == 0 ?  () {
                    _authController.resendOtp("${parameters["email"]}");
                    _otpController.clear(); // Clear the local OTP controller
                    resetTimer();
                  } : null,
                  child: CustomText(
                    text: AppStrings.sendCodeAgain.tr,
                    fontSize: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 239.h),
              //============================> Confirm Button <===================================
              Obx(()=> CustomButton(
                  loading: _authController.forgotOtpLoading.value,
                  onTap: () {
                    _authController.otpVerifyForgotPass(
                        email: "${parameters["email"]}",
                        otp: _authController.otpCtrlForgot.text,
                        screenType: "${parameters["screenType"]}");
                  },

                  text: AppStrings.confirm.tr),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
