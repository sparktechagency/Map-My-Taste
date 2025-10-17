import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_images.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/bottom_menu..dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import 'InnerWidget/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(0),
      //=======================================> App Bar Section <===================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            Spacer(),
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.notification,
                width: 24.w,
                height: 24.h,
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.message,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
      //=======================================> Body Section <===================================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //=======================================> Search And Filter Row <===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 328.w,
                    child: CustomTextField(
                      controller: searchCTRL,
                      hintText: AppStrings.searchForRestaurants.tr,
                      prefixIcon: SvgPicture.asset(AppIcons.search),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(AppIcons.filter),
                  ),
                ],
              ),
              //=======================================> Post Card Section <===================================
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return PostCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
