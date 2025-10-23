import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/views/base/bottom_menu..dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_network_image.dart';
import '../../base/custom_text_field.dart';
import 'InnerWidget/trending_place_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(3),
      //=======================================> App Bar Section <===================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            Spacer(),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.notificationsScreen);
              },
              child: SvgPicture.asset(
                AppIcons.notification,
                width: 24.w,
                height: 24.h,
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.conversationScreen);
              },
              child: SvgPicture.asset(
                AppIcons.message,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: searchCTRL,
                hintText: AppStrings.searchForRestaurants.tr,
                prefixIcon: SvgPicture.asset(AppIcons.search),
              ),
              SizedBox(height: 24.h),
              //=============================> Top categories <=========================
              SizedBox(
                height: 110.h,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _topCategory(
                      SvgPicture.asset(AppIcons.restaurants),
                      'Restaurants',
                    ),
                    _topCategory(SvgPicture.asset(AppIcons.hotel), 'Hotel'),
                    _topCategory(
                      SvgPicture.asset(AppIcons.things),
                      'Things to do',
                    ),
                    _topCategory(SvgPicture.asset(AppIcons.museums), 'Museums'),
                    _topCategory(
                      SvgPicture.asset(AppIcons.pharmacies),
                      'Pharmacies',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              //====================================> Trending Places <============================
              CustomText(
                text: AppStrings.trendingPlaces.tr,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 16.h),
              //====================================> Trending Places <============================
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TrendingPlaceCard(
                      imageUrl:
                          'https://img.freepik.com/free-photo/woman-eating-tomato-salad-with-mozzarella-mint-served-with-white-wine_141793-2465.jpg?semt=ais_hybrid&w=740&q=80',
                      name: 'Motin Miar Pizza Ghur',
                      rating: 4.9,
                      time: '0.5 min',
                    ),
                    TrendingPlaceCard(
                      imageUrl:
                          'https://img.freepik.com/free-photo/woman-eating-tomato-salad-with-mozzarella-mint-served-with-white-wine_141793-2465.jpg?semt=ais_hybrid&w=740&q=80',
                      name: 'Motin Miar Pizza Ghur',
                      rating: 4.9,
                      time: '0.5 min',
                    ),
                    TrendingPlaceCard(
                      imageUrl:
                          'https://img.freepik.com/free-photo/woman-eating-tomato-salad-with-mozzarella-mint-served-with-white-wine_141793-2465.jpg?semt=ais_hybrid&w=740&q=80',
                      name: 'Motin Miar Pizza Ghur',
                      rating: 4.9,
                      time: '0.5 min',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              //====================================> Nearby Places <============================
              CustomText(
                text: AppStrings.nearbyPlaces.tr,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                // padding: EdgeInsets.all(16.w),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.fillColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Row(
                          children: [
                            CustomNetworkImage(
                              imageUrl:
                                  'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                              height: 64.h,
                              width: 64.w,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          text: 'Motin Miar Pizza Ghar',
                                          fontSize: 20.sp,
                                          textAlign: TextAlign.start,
                                          maxLine: 2,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          CustomText(
                                            text: '4.9',
                                            color: AppColors.greyColor,
                                            fontSize: 16.sp,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: AppStrings.restaurants.tr,
                                        fontSize: 16.sp,
                                        color: AppColors.greyColor,
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5.w),
                                          CustomText(
                                            text: '0.5 km',
                                            color: AppColors.greyColor,
                                            fontSize: 16.sp,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryButtonColor,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 4.h,
                                          ),
                                          child: CustomText(
                                            text: AppStrings.open.tr,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              //====================================> Nearby Places <============================
              Container(
                decoration: BoxDecoration(
                  color: AppColors.fillColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      Image.asset(AppImages.logo, width: 162.w, height: 37.h),
                      CustomText(
                        text:
                            'Start Exploring the best places near you and share your experiences with the community.',
                        maxLine: 5,
                      ),
                      SizedBox(height: 16.h),

                      CustomButton(onTap: () {}, text: 'Explore Places'.tr),
                      SizedBox(height: 16.h),
                      CustomButton(
                        color: AppColors.backgroundColor,
                        onTap: () {},
                        text: 'Explore Places'.tr,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  //================================================> Top Category <================================
  Padding _topCategory(Widget icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          icon,
          SizedBox(height: 8.h),
          CustomText(text: title, fontSize: 16.sp),
        ],
      ),
    );
  }
}
