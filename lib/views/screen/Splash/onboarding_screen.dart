import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_images.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _showGetStarted = false;
  int _currentPage = 0;

  void _onGetStarted() {
    setState(() {
      _showGetStarted = true;
    });
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    if(_currentPage == 3){
      Get.toNamed(AppRoutes.signInScreen);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
        child: Column(
          children: [
            SizedBox(height: 36.h),
            //=============================> Skip Button <====================================
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {},
                child: CustomText(
                  text: AppStrings.skip.tr,
                  fontSize: 16.sp,
                  textDecoration: TextDecoration.underline,
                  color: AppColors.greyColor,
                  bottom: 16.h,
                ),
              ),
            ),
            //=============================> PageView with the onboarding pages <====================================
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _firstOnboard(),
                  _secondOnboard(),
                  _thirdOnboard(),
                  _fourthOnboard(),
                ],
              ),
            ),
            //========================> Progress Indicator (progress bar) <=================================
            CustomProgressBar(progress: (_currentPage + 1) / 4),
            SizedBox(height: 32.h),
            //==============================> Get Started Button <====================================
            CustomButton(
              onTap: _onGetStarted,
              text: _currentPage == 0
                  ? AppStrings.getStarted.tr
                  : AppStrings.next.tr,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

//===========================================> Custom Progress Bar <================================
class CustomProgressBar extends StatelessWidget {
  final double progress;
  const CustomProgressBar({super.key, required this.progress});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        Color color;
        if (index < (progress * 4).toInt()) {
          color = AppColors.primaryColor;
        } else {
          color = Colors.grey.shade800;
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: 72.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.r),
          ),
        );
      }),
    );
  }
}

//===========================================> First Onboard Method <================================
Container _firstOnboard() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: AppStrings.welcomeTo.tr,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: <TextSpan>[
              TextSpan(text: ' '),
              TextSpan(
                text: AppStrings.mapMyTaste.tr,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.getReadyToExplore.tr,
          fontSize: 16.sp,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 24.h),
        Image.asset(AppImages.onboard1, height: 300.h, width: 399.w),
        SizedBox(height: 24.h),
        CustomText(
          text: AppStrings.discoverRestaurants.tr,
          fontSize: 16.sp,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
      ],
    ),
  );
}

//===========================================> Second Onboard Method <================================
Container _secondOnboard() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.trackYourPlacesVisited.tr,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          maxLine: 5,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.neverForgetThePlaces.tr,
          fontSize: 16.sp,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 24.h),
        Image.asset(AppImages.onboard2, height: 300.h, width: 399.w),
        SizedBox(height: 24.h),
        CustomText(
          text: AppStrings.placesVisited.tr,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          color: AppColors.primaryColor,
        ),
        CustomText(
          text: AppStrings.trackALlThePlaces.tr,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.recordOfExperience.tr,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          color: AppColors.primaryColor,
        ),
        CustomText(
          text: AppStrings.keepALog.tr,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
      ],
    ),
  );
}

//===========================================> Third Onboard Method <================================
Container _thirdOnboard() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.shareYourReviews.tr,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          maxLine: 5,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.letOthersKnow.tr,
          fontSize: 16.sp,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 24.h),
        Image.asset(AppImages.onboard3, height: 300.h, width: 399.w),
        SizedBox(height: 24.h),
        CustomText(
          text: AppStrings.writeReviews.tr,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          color: AppColors.primaryColor,
        ),
        CustomText(
          text: AppStrings.expressYourThoughts.tr,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.ratings.tr,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          color: AppColors.primaryColor,
        ),
        CustomText(
          text: AppStrings.ratePlaces.tr,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
      ],
    ),
  );
}

//===========================================> Fourth Onboard Method <================================
Container _fourthOnboard() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.saveYourFavorites.tr,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          maxLine: 5,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.keepAPersonalList.tr,
          fontSize: 16.sp,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 24.h),
        Image.asset(AppImages.onboard4, height: 300.h, width: 399.w),
        SizedBox(height: 24.h),
        CustomText(
          text: AppStrings.savePlaces.tr,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          color: AppColors.primaryColor,
        ),
        CustomText(
          text: AppStrings.favoriteAnyPlace.tr,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 16.h),
        CustomText(
          text: AppStrings.organizeFavorites.tr,
          fontSize: 16.sp,
          textAlign: TextAlign.start,
          color: AppColors.primaryColor,
        ),
        CustomText(
          text: AppStrings.easilyManageYourList.tr,
          maxLine: 5,
          textAlign: TextAlign.start,
          color: AppColors.greyColor,
        ),
      ],
    ),
  );
}
