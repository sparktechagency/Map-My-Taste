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

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavouriteController controller = Get.put(FavouriteController());
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    // Load first page
    controller.getFavourites();

    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreFavourites();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.getFavourites();

    return Scaffold(
      bottomNavigationBar: BottomMenu(2),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: CustomText(
            text: AppStrings.favorites.tr,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700),
      ),
      body:
      Obx(() {
        if (controller.isFetching.value && controller.favourites.isEmpty) {
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
          controller: scrollController,
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: controller.favourites.length +
              (controller.isPaginating.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Pagination loader at bottom
            if (index == controller.favourites.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final item = controller.favourites[index];
            return PostCard(fav: item);
          },
        );
      }),
    );
  }
}
