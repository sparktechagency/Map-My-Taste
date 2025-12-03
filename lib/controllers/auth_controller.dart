import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../helpers/prefs_helpers.dart';
import '../helpers/route.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

class AuthController extends GetxController {
  //================================> Sign Up <=================================
  final TextEditingController signUpNameCTRL = TextEditingController();
  final TextEditingController signUpEmailCTRL = TextEditingController();
  final TextEditingController signUpPhoneNumberCTRL = TextEditingController();
  final TextEditingController signUpAddressCTRL = TextEditingController();
  final TextEditingController signUpGenderCTRL = TextEditingController();
  final TextEditingController signUpPassCTRL = TextEditingController();
  final TextEditingController signUpConfirmPassCTRL = TextEditingController();
  String? selectedGender;
  bool isChecked = false;
  var signUpLoading = false.obs;
  var resetPasswordLoading = false.obs;
  var userToken = "";

  signUp() async {
    signUpLoading(true);
    Map<String, dynamic> body = {
      "fullName": signUpNameCTRL.text.trim(),
      "email": signUpEmailCTRL.text.trim(),
      "phoneNumber": signUpPhoneNumberCTRL.text,
      "address": signUpAddressCTRL.text,
      "gender": selectedGender,
      "password": signUpPassCTRL.text,
      "confirmPassword": signUpConfirmPassCTRL.text,
      "acceptTerms": isChecked,
    };

    var headers = {'Content-Type': 'application/json'};

    Response response = await ApiClient.postData(
      ApiConstants.signUpEndPoint,
      jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['verificationToken']);
      Get.toNamed(
        AppRoutes.otpScreen,
        parameters: {
          "email": signUpEmailCTRL.text.trim(),
          "screenType": "signup",
        },
      );
      signUpNameCTRL.clear();
      signUpEmailCTRL.clear();
      signUpPhoneNumberCTRL.clear();
      signUpAddressCTRL.clear();
      signUpGenderCTRL.clear();
      selectedGender = '';
      signUpPassCTRL.clear();
      signUpConfirmPassCTRL.clear();
      isChecked = false;
      signUpLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      Fluttertoast.showToast(msg: response.statusText ?? "");
      signUpLoading(false);
      update();
    }
  }

//===================> Otp very <=======================
  TextEditingController otpCtrl = TextEditingController();
  var otpLoading = false.obs;

  handleOtpVery({
    required String email,
    required String otp,
    required String screenType
  }) async {
    try {
      // Clean and validate the OTP before sending for email verification (signup)
      String cleanOtp = otp.trim(); // Remove any spaces

      // For email verification during signup, we might not need the same strict 6-digit validation
      // as the endpoint might be different. Just ensure it's not empty.
      if (cleanOtp.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter the OTP");
        otpLoading(false);
        return;
      }

      var body = {'otp': cleanOtp};
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await PrefsHelper.getString(AppConstants.bearerToken)}'
      };

      otpLoading(true);

      Response response = await ApiClient.postData(
        ApiConstants.otpVerifyEndPoint,
        jsonEncode(body),
        headers: headers,
      );

      print("Response Body: ${response.body} | Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print('OTP Verified Successfully');

        if (screenType == "forgetPasswordScreen") {
          Get.offAllNamed(
            AppRoutes.resetPasswordScreen,
          );
        } else {
          Get.offAllNamed(AppRoutes.signInScreen);
        }
      } else {
        ApiChecker.checkApi(response);
        Fluttertoast.showToast(msg: response.statusText ?? "Verification failed");
      }
    } catch (e, s) {
      print("Error: $e");
      print("Stack trace: $s");
      Fluttertoast.showToast(msg: "An error occurred");
    } finally {
      otpLoading(false);
    }
  }

  //=================> Resend otp <=====================
  var resendOtpLoading = false.obs;
  resendOtp(String email) async {
    resendOtpLoading(true);
    var body = {"email": email};
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await PrefsHelper.getString(AppConstants.bearerToken)}'
    };
    var response = await ApiClient.postData(
      ApiConstants.resendOtpEndPoint,
      json.encode(body),
      headers: headers,
    );
    print("===> ${response.body}");
    if (response.statusCode == 200) {
    } else {
      Fluttertoast.showToast(
        msg: response.statusText ?? "",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER,
      );
    }
    resendOtpLoading(false);
  }

  //==========================> Show Calender Function <========================
  /*Future<void> pickBirthDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: Colors.black, // Text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dateOfBirthCtrl.text = "${_getMonthName(pickedDate.month)} ${pickedDate.day}, ${pickedDate.year}";

    }
  }*/

  // Helper function to convert month number to name
  String _getMonthName(int month) {
    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  //======================> Select Country and Birth Day <======================
  final TextEditingController countryCTRL = TextEditingController();
  final TextEditingController birthDayCTRL = TextEditingController();
  var selectCountryLoading = false.obs;

  /*selectCountry() async {
    selectCountryLoading(true);
    update();
    Map<String, dynamic> body = {
      "country": countryCTRL.text.trim(),
      "dataOfBirth": birthDayCTRL.text.trim(),
    };
    Response response = await ApiClient.putData(
        ApiConstants.profileDataEndPoint, jsonEncode(body));
    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.signInScreen);
      countryCTRL.clear();
      birthDayCTRL.clear();
    } else {
      ApiChecker.checkApi(response);
    }

    selectCountryLoading(false);
    update();
  }*/

  //==================================> Sign In <================================
  TextEditingController signInEmailCtrl = TextEditingController();
  TextEditingController signInPassCtrl = TextEditingController();
  var signInLoading = false.obs;
  signIn() async {
    signInLoading(true);
    var headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'email': signInEmailCtrl.text.trim(),
      'password': signInPassCtrl.text.trim(),
     // "fcmToken": "fcmToken..",
    };
    Response response = await ApiClient.postData(
      ApiConstants.signInEndPoint,
      json.encode(body),
      headers: headers,
    );
    print("====> ${response.body}");
    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['accessToken']);
      await PrefsHelper.setString(AppConstants.id, response.body['data']['user']['id']);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      Get.offAllNamed(AppRoutes.homeScreen);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      signInEmailCtrl.clear();
      signInPassCtrl.clear();
      signInLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      Fluttertoast.showToast(msg: response.statusText ?? "");
    }
    signInLoading(false);
  }

  //====================> Forgot password <=====================
  TextEditingController forgetEmailTextCtrl = TextEditingController();
  var forgotLoading = false.obs;

  forgetPassword() async {
    forgotLoading(true);
    var body = {"email": forgetEmailTextCtrl.text.trim()};
    var headers = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
      ApiConstants.forgotPasswordEndPoint,
      json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(
        AppRoutes.forgotOtpScreen,
        parameters: {
          "email": forgetEmailTextCtrl.text.trim(),
          "screenType": "forgetPasswordScreen",
        },
      );
      forgetEmailTextCtrl.clear();
      forgotLoading(false);
    } else {
      ApiChecker.checkApi(response);
    }
    forgotLoading(false);
  }

  //===================> Otp very Forgot Password <=======================
  TextEditingController otpCtrlForgot = TextEditingController();
  var forgotOtpLoading = false.obs;

  otpVerifyForgotPass({
    required String email,
    required String otp,
    required String screenType,
  }) async {
    try {
      forgotOtpLoading(true);

      String cleanEmail = email.trim();
      String cleanOtp = otp.trim();

      // Ensure OTP is exactly 6 digits
      if (cleanOtp.length != 6) {
        Fluttertoast.showToast(msg: "OTP must be exactly 6 digits");
        forgotOtpLoading(false);
        return;
      }

      if (!RegExp(r'^\d{6}$').hasMatch(cleanOtp)) {
        Fluttertoast.showToast(msg: "OTP must contain only numbers");
        forgotOtpLoading(false);
        return;
      }
      Map<String, String> body = {
        'email': cleanEmail,
        'otp': cleanOtp,
      };

      Map<String, String> header = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      Response response = await ApiClient.postData(
        ApiConstants.verifyResetOtpEndPoint,
        body,
        headers: header,
      );

      print("Forgot Password OTP Response: ${response.body} | Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        forgotOtpLoading(false);
        var data = response.body is String ? jsonDecode(response.body) : response.body;

        if (data['data']?['resetPasswordToken'] != null) {
          await PrefsHelper.setString(AppConstants.bearerToken, data['data']['resetPasswordToken']);
        } else if (data['data']?['accessToken'] != null) {
          await PrefsHelper.setString(AppConstants.bearerToken, data['data']['accessToken']);
        }
        Get.offAllNamed(AppRoutes.resetPasswordScreen);
        Fluttertoast.showToast(msg: data['message'] ?? "OTP verified");
      } else {
        ApiChecker.checkApi(response);
        Fluttertoast.showToast(msg: response.statusText ?? "Verification failed");
      }
    } catch (e, s) {
      print("Error in otpVerifyForgotPass: $e");
      print("Stack trace: $s");
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      forgotOtpLoading(false);
    }
  }

  //======================> Change password <============================
  var changePassLoading = false.obs;
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  handleChangePassword(String oldPassword, String newPassword) async {
    changePassLoading(true);
    var body = {"currentPassword": oldPassword, "password": newPassword};
    var response = await ApiClient.postData(
      ApiConstants.changePasswordEndPoint,
      body,
    );
    print("===============> ${response.body}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: response.body['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColors.cardLightColor,
        textColor: Colors.white,
      );
      Get.back();
      Get.back();
    } else {
      ApiChecker.checkApi(response);
    }
    changePassLoading(false);
  }

  //=============================> Set New password <===========================
  resetPassword(String password, String confirmPassword) async {
    print("=======> $password, and $confirmPassword");
    resetPasswordLoading(true);
    var body = {"password": password, "confirmPassword": confirmPassword};

    // Get the reset token that was saved after successful OTP verification
    String resetToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var header = {
      'Content-Type': 'application/json',
    };

    // Add Authorization header with the reset token if it exists
    if (resetToken != null && resetToken.isNotEmpty) {
      header['Authorization'] = 'Bearer $resetToken';
    }

    var response = await ApiClient.postData(
      ApiConstants.resetPasswordEndPoint,
      json.encode(body),
      headers: header,
    );
    if (response.statusCode == 200) {
      // Clear the temporary token after successful password reset
      await PrefsHelper.remove(AppConstants.bearerToken);

      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.cardLightColor,
          title: const Text("Password reset!"),
          content: const Text("Your password has been reset successfully."),
          actions: [
            TextButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                Get.toNamed(AppRoutes.signInScreen);
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    } else {
      debugPrint("error set password ${response.statusText}");
      Fluttertoast.showToast(msg: "${response.statusText}");
    }
    resetPasswordLoading(false);
  }
}

//======================> Google login Info <============================
/*handleGoogleSingIn(String email,String userRole) async {
    var fcmToken=await PrefsHelper.getString(AppConstants.fcmToken);

    Map<String, dynamic> body =
    {
      "email": email,
      "fcmToken": fcmToken ?? "",
       "role": userRole,
      "loginType": 2
    };

    var headers = {'Content-Type': 'application/json'};
    Response response = await ApiClient.postData(ApiConstants.logInEndPoint, jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['attributes']['tokens']['access']['token']);
      await PrefsHelper.setString(AppConstants.userId, response.body['data']['attributes']['user']['id']);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      Get.offAllNamed(AppRoutes.homeScreen);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }*/

//======================> Facebook login Info <============================
/*handleFacebookSignIn(String email,String userRole) async {
    var fcmToken = await PrefsHelper.getString(AppConstants.fcmToken);

    Map<String, dynamic> body = {
      "email": email,
      "fcmToken": fcmToken ?? "",
       "role": userRole,
      "loginType": 3
    };

    var headers = {'Content-Type': 'application/json'};
    Response response = await ApiClient.postData(
      ApiConstants.logInEndPoint,
      jsonEncode(body),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken, response.body['data']['attributes']['tokens']['access']['token']);
      await PrefsHelper.setString(AppConstants.userId, response.body['data']['attributes']['user']['id']);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      Get.offAllNamed(AppRoutes.homeScreen);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }*/
