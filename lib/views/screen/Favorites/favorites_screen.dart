import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/bottom_menu..dart';

import '../../../controllers/favourite_controller.dart';
import '../../../utils/app_colors.dart';
import '../../base/custom_page_loading.dart';
import '../../base/custom_text.dart';
import 'InnerWidget/post_card.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final FavouriteController controller = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    controller.getFavourites(); // load on screen open

    return Scaffold(
      bottomNavigationBar: BottomMenu(2),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: CustomText(
            text: AppStrings.favorites.tr,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700),
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return Center(child: CustomPageLoading());
        }

        if (controller.favourites.isEmpty) {
          return Center(
            child: CustomText(
              text: "No favorites found",
              fontSize: 18.sp,
              color: Colors.white,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: controller.favourites.length,
          itemBuilder: (context, index) {
            final item = controller.favourites[index];
            return PostCard(fav: item);  // pass data to UI
          },
        );
      }),
    );
  }
}
