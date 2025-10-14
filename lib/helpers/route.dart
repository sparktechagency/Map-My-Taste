import 'package:get/get.dart';
import '../views/screen/Auth/sign_in_screen.dart';
import '../views/screen/Auth/sign_up_screen.dart';
import '../views/screen/Location/location_picker_screen.dart';
import '../views/screen/Location/location_screen.dart';
import '../views/screen/Splash/onboarding_screen.dart';
import '../views/screen/Splash/splash_screen.dart';

class AppRoutes{
  static String splashScreen="/splash_screen";
  static String onboardingScreen="/onboarding_screen";
  static String signInScreen="/sign_in_screen";
  static String signUpScreen="/sign_up_screen";
  static String homeScreen="/home_screen";
  static String profileScreen="/profile_screen";
  static String categoriesScreen="/categories_screen";
  static String locationScreen="/location_screen";
  static String locationPickerScreen="/location_picker_screen";

 static List<GetPage> page=[
    GetPage(name:splashScreen, page: ()=>const SplashScreen()),
    GetPage(name:onboardingScreen, page: ()=>const OnboardingScreen()),
    GetPage(name:signInScreen, page: ()=> SignInScreen()),
    GetPage(name:signUpScreen, page: ()=> SignUpScreen()),
  //  GetPage(name:homeScreen, page: ()=>const HomeScreen(),transition:Transition.noTransition),
  //  GetPage(name:categoriesScreen, page: ()=>const CategoriesScreen(),transition:Transition.noTransition),
   // GetPage(name:profileScreen, page: ()=>const ProfileScreen(),transition: Transition.noTransition),
   // GetPage(name:locationScreen, page: ()=>const LocationScreen(),transition: Transition.noTransition),
    //GetPage(name:locationPickerScreen, page: ()=>const LocationPickerScreen(),transition: Transition.noTransition),
  ];
}
