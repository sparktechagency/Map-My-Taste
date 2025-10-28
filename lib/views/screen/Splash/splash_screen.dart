import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed( Duration(seconds: 6), () {
  /*var isLogged = await PrefsHelper.getBool(AppConstants.isLogged);
      if (isLogged == true) {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      }*/

      Get.offAllNamed(AppRoutes.onboardingScreen);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.gif', width: double.infinity),
      ),
      
    );
  }
}
