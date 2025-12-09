class ApiConstants {
  //=============================> Authentication <=============================
  static const String baseUrl = "http://mapmytaste.merinasib.shop/api/v1";
  static const String imageBaseUrl = "http://mapmytaste.merinasib.shop";
  static const String signUpEndPoint = "/auth/register";
  static const String otpVerifyEndPoint = "/auth/verify-email";
  static const String resendOtpEndPoint = "/auth/resend-otp";
  static const String setLocationEndPoint = "/auth/register-with-location";
  static const String signInEndPoint = "/auth/login";
  static const String resendVerificationEndPoint = "/auth/resend-verification";
  static const String googleSignInEndPoint = "/auth/google-auth";
  static const String refreshAuthEndPoint = "/auth/refresh-auth";
  static const String logOutEndPoint = "/auth/logout";
  static const String forgotPasswordEndPoint = "/auth/forgot-password";
  static const String verifyResetOtpEndPoint = "/auth/verify-reset-otp";
  static const String resetPasswordEndPoint = "/auth/reset-password";
  static const String changePasswordEndPoint = "/auth/change-password";
  static const String getProfileDataEndPoint = "/users/profile";

//=============================> Business / Search <=============================
  static const String searchNearbyBusinessesEndPoint = "/businesses/search/nearby";
  static const String getBusinessDetails = "/businesses/";
  static const String getCategoryList = "/businesses/categories/all";

  static const String termsConditionEndPoint = "";
  static const String privacyPolicyEndPoint = "";
  static const String aboutUsEndPoint = "";
}
