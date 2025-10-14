/*
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
  //================================> User Sign Up <=================================
  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController userEmailCtrl = TextEditingController();
  final TextEditingController userNumberCtrl = TextEditingController();
  final TextEditingController userPasswordCtrl = TextEditingController();
  final TextEditingController userConfirmCtrl = TextEditingController();
  var userSignUpLoading = false.obs;
  var userToken = "";

  userSignUp() async {
    userSignUpLoading(true);
    var userRole = await PrefsHelper.getString(AppConstants.userRole);
    Map<String, dynamic> body = {
      "userName": userNameCtrl.text.trim(),
      "email": userEmailCtrl.text.trim(),
      "phoneNumber": userNumberCtrl.text,
      "password": userPasswordCtrl.text,
      "role": userRole,
      "type": userRole,
    };

    var headers = {'Content-Type': 'application/json'};

    Response response = await ApiClient.postData(
        ApiConstants.signUpEndPoint, jsonEncode(body),
        headers: headers);
    if (response.statusCode == 201 || response.statusCode == 200) {
      Get.toNamed(AppRoutes.otpScreen, parameters: {
        "email": userEmailCtrl.text.trim(),
        "screenType": "signup",
      });
      userNameCtrl.clear();
      userEmailCtrl.clear();
      userNumberCtrl.clear();
      userPasswordCtrl.clear();
      userConfirmCtrl.clear();
      userSignUpLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      userSignUpLoading(false);
      update();
    }
  }

  //================================> Driver Sign Up <=================================
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController dateOfBirthCtrl = TextEditingController();
  final TextEditingController vehiclesTypeCtrl = TextEditingController();
  final TextEditingController vehiclesModelCtrl = TextEditingController();
  final TextEditingController licenseNumberCtrl = TextEditingController();

  // RxBool isSelectedRole = true.obs;
  var signUpLoading = false.obs;
  var token = "";

  driverSignUp() async {
    signUpLoading(true);
    var userRole = await PrefsHelper.getString(AppConstants.userRole);
    Map<String, dynamic> body = {
      "userName": nameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "password": passwordCtrl.text,
      "address": addressCtrl.text,
      "dateOfBirth": dateOfBirthCtrl.text,
      "vehicleType": vehiclesTypeCtrl.text,
      "vehicleModel": vehiclesModelCtrl.text,
      "licensePlateNumber": licenseNumberCtrl.text,
      "role": userRole,
    };

    var headers = {'Content-Type': 'application/json'};

    Response response = await ApiClient.postData(
        ApiConstants.signUpEndPoint, jsonEncode(body),
        headers: headers);
    if (response.statusCode == 201 || response.statusCode == 200) {
      Get.toNamed(AppRoutes.otpScreen, parameters: {
        "email": emailCtrl.text.trim(),
        "screenType": "signup",
      });
      nameCtrl.clear();
      emailCtrl.clear();
      passwordCtrl.clear();
      confirmCtrl.clear();
      addressCtrl.clear();
      dateOfBirthCtrl.clear();
      vehiclesTypeCtrl.clear();
      vehiclesModelCtrl.clear();
      licenseNumberCtrl.clear();
      signUpLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      signUpLoading(false);
      update();
    }
  }

  //===================> Otp very <=======================
  TextEditingController otpCtrl = TextEditingController();
  var otpVerifyLoading = false.obs;
  otpVery(
      {required String email,
        required String otp,
        required String type}) async {
    try {
      var body = {'oneTimeCode': otpCtrl.text, 'email': email};
      var headers = {'Content-Type': 'application/json'};
      otpVerifyLoading(true);
      Response response = await ApiClient.postData(
          ApiConstants.otpEndPoint, jsonEncode(body),
          headers: headers);
      print("============${response.body} and ${response.statusCode}");
      if (response.statusCode == 200) {
        print('token===============>>>>${response.body["data"]['attributes']['tokens']['access']['token']}');
        await PrefsHelper.setString(AppConstants.userRole,
            response.body["data"]['attributes']['user']['role']);
        await PrefsHelper.setString(AppConstants.bearerToken,
            response.body["data"]['attributes']['tokens']['access']['token']);
        var role = response.body["data"]['attributes']['user']['role'];
        print("===> role : $role");
        otpCtrl.clear();
        if (type == "forgetPasswordScreen") {
          Get.toNamed(AppRoutes.resetPasswordScreen,
              parameters: {"email": email});
        } else {
          Get.toNamed(AppRoutes.signInScreen);
        }
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e, s) {
      print("===> e : $e");
      print("===> s : $s");
    }
    otpVerifyLoading(false);
  }

//=================> Resend otp <=====================
  var resendOtpLoading = false.obs;
  resendOtp(String email) async {
    resendOtpLoading(true);
    var body = {"email": email};
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
        ApiConstants.forgotPassEndPoint, json.encode(body),
        headers: header);
    print("===> ${response.body}");
    if (response.statusCode == 200) {
    } else {
      Fluttertoast.showToast(
          msg: response.statusText ?? "",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
    }
    resendOtpLoading(false);
  }



  //==========================> Show Calender Function <========================
  Future<void> pickBirthDate(BuildContext context) async {
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
  }
  // Helper function to convert month number to name
  String _getMonthName(int month) {
    const List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  //======================> Select Country and Birth Day <======================
  final TextEditingController countryCTRL = TextEditingController();
  final TextEditingController birthDayCTRL = TextEditingController();
  var selectCountryLoading = false.obs;

  */
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
  }*//*


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
      "fcmToken": "fcmToken..",
    };
    Response response = await ApiClient.postData(
        ApiConstants.signInEndPoint, json.encode(body),
        headers: headers);
    print("====> ${response.body}");
    if (response.statusCode == 200) {
      await PrefsHelper.setString(AppConstants.bearerToken,
          response.body['data']['attributes']['tokens']['access']['token']);
      await PrefsHelper.setString(
          AppConstants.id, response.body['data']['attributes']['user']['id']);
      String userRole = response.body['data']['attributes']['user']['role'];
      await PrefsHelper.setString(AppConstants.userRole, userRole);
      await PrefsHelper.setBool(AppConstants.isLogged, true);
      if (userRole == 'user') {
        Get.offAllNamed(AppRoutes.userInboxScreen);
        await PrefsHelper.setBool(AppConstants.isLogged, true);
      } else if (userRole == 'driver') {
        Get.offAllNamed(AppRoutes.driverHomeScreen);
      }
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
    var body = {
      "email": forgetEmailTextCtrl.text.trim(),
    };
    var headers = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
        ApiConstants.forgotPassEndPoint, json.encode(body),
        headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.toNamed(AppRoutes.otpScreen, parameters: {
        "email": forgetEmailTextCtrl.text.trim(),
        "screenType": "forgetPasswordScreen",
      });
      forgetEmailTextCtrl.clear();
    } else {
      ApiChecker.checkApi(response);
    }
    forgotLoading(false);
  }

  //======================> Change password <============================
  var changePassLoading = false.obs;
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  changePassword(String oldPassword, String newPassword) async {
    changePassLoading(true);
    var body = {"oldPassword": oldPassword, "newPassword": newPassword};
    var response = await ApiClient.postData(ApiConstants.changePassEndPoint, body);
    print("===============> ${response.body}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: response.body['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: AppColors.cardLightColor,
          textColor: Colors.white);
      Get.back();
      Get.back();
    } else {
      ApiChecker.checkApi(response);
    }
    changePassLoading(false);
  }

  //=============================> Set New password <===========================
  var resetPasswordLoading = false.obs;
  resetPassword(String email, String password) async {
    print("=======> $email, and $password");
    resetPasswordLoading(true);
    var body = {"email": email, "password": password};
    Map<String, String> header = {'Content-Type': 'application/json'};
    var response = await ApiClient.postData(
        ApiConstants.resetPassEndPoint, json.encode(body),
        headers: header);
    if (response.statusCode == 200) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.cardLightColor,
            title: const Text("Password reset!"),
            content:
            const Text("Your password has been reset successfully."),
            actions: [
              TextButton(
                  style: const ButtonStyle(
                      backgroundColor:
                      WidgetStatePropertyAll(Colors.white)),
                  onPressed: () {
                    Get.toNamed(AppRoutes.signInScreen);
                  },
                  child: const Text("Ok"))
            ],
          ));
    } else {
      debugPrint("error set password ${response.statusText}");
      Fluttertoast.showToast(
        msg: "${response.statusText}",
      );
    }
    resetPasswordLoading(false);
  }
}

//======================> Google login Info <============================
*/
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
  }*//*


//======================> Facebook login Info <============================
*/
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
    }*//*



*/
