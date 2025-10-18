import 'package:get/get.dart';
import '../views/screen/Auth/change_password_screen.dart';
import '../views/screen/Auth/forgot_password_screen.dart';
import '../views/screen/Auth/otp_screen.dart';
import '../views/screen/Auth/reset_password_screen.dart';
import '../views/screen/Auth/sign_in_screen.dart';
import '../views/screen/Auth/sign_up_screen.dart';
import '../views/screen/Conversation/chat_screen.dart';
import '../views/screen/Conversation/conversation_screen.dart';
import '../views/screen/Home/home_screen.dart';
import '../views/screen/Location/location_picker_screen.dart';
import '../views/screen/Location/location_screen.dart';
import '../views/screen/Profile/edit_profile_screen.dart';
import '../views/screen/Profile/profile_screen.dart';
import '../views/screen/ReportAProblem/report_problem_screen.dart';
import '../views/screen/Splash/onboarding_screen.dart';
import '../views/screen/Splash/splash_screen.dart';
import '../views/screen/Terms&Policies/terms_policies_screen.dart';

class AppRoutes{
  static String splashScreen="/splash_screen";
  static String onboardingScreen="/onboarding_screen";
  static String signInScreen="/sign_in_screen";
  static String signUpScreen="/sign_up_screen";
  static String forgotPasswordScreen="/forgot_password_screen";
  static String resetPasswordScreen="/reset_password_screen";
  static String changePasswordScreen="/change_password_screen";
  static String otpScreen="/otp_screen";
  static String reportProblemScreen="/report_problem_screen";
  static String termsPoliciesScreen="/terms_policies_screen";
  static String homeScreen="/home_screen";
  static String profileScreen="/profile_screen";
  static String editProfileScreen="/edit_profile_screen";
  static String categoriesScreen="/categories_screen";
  static String conversationScreen="/conversation_screen";
  static String chatScreen="/chat_screen";
  static String locationScreen="/location_screen";
  static String locationPickerScreen="/location_picker_screen";

 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:onboardingScreen, page: ()=>const OnboardingScreen()),
    GetPage(name:signInScreen, page: ()=> SignInScreen()),
    GetPage(name:signUpScreen, page: ()=> SignUpScreen()),
    GetPage(name:forgotPasswordScreen, page: ()=> ForgotPasswordScreen()),
    GetPage(name:resetPasswordScreen, page: ()=> ResetPasswordScreen()),
    GetPage(name:changePasswordScreen, page: ()=> ChangePasswordScreen()),
    GetPage(name:otpScreen, page: ()=> OtpScreen()),
    GetPage(name:reportProblemScreen, page: ()=> ReportProblemScreen()),
    GetPage(name:termsPoliciesScreen, page: ()=> TermsPoliciesScreen()),
    GetPage(name:conversationScreen, page: ()=> ConversationScreen()),
    GetPage(name:chatScreen, page: ()=> ChatScreen()),
    GetPage(name:homeScreen, page: ()=> HomeScreen(),transition:Transition.noTransition),
  //  GetPage(name:categoriesScreen, page: ()=>const CategoriesScreen(),transition:Transition.noTransition),
    GetPage(name:profileScreen, page: ()=>const ProfileScreen(),transition: Transition.noTransition),
    GetPage(name:editProfileScreen, page: ()=>const EditProfileScreen()),
   // GetPage(name:locationScreen, page: ()=>const LocationScreen(),transition: Transition.noTransition),
    //GetPage(name:locationPickerScreen, page: ()=>const LocationPickerScreen(),transition: Transition.noTransition),
  ];
}
