import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_app_bar.dart';
import 'package:map_my_taste/views/base/custom_network_image.dart';
import 'package:map_my_taste/views/base/custom_text.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.message.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 25,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.toNamed(AppRoutes.chatScreen);
                          },
                          child: Row(
                            children: [
                              CustomNetworkImage(
                                imageUrl:
                                    'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                                height: 56.h,
                                width: 56.w,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'Motin miar Pizza Ghur',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.start,
                                      bottom: 8.h,
                                    ),
                                    CustomText(
                                      text: 'Hey there, how can I help you?',
                                      fontSize: 16.sp,
                                      color: AppColors.greyColor,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                              CustomText(
                                text: '24/09/2025',
                                fontSize: 16.sp,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 0.3, color: AppColors.greyColor)
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
