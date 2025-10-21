import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/bottom_menu..dart';

import '../../../utils/app_colors.dart';
import '../../base/custom_text.dart';
import 'InnerWidget/post_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(2),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: CustomText(text: AppStrings.favorites.tr, fontSize: 22.sp, fontWeight: FontWeight.w700),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
    );
  }
}
