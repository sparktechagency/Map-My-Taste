import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/models/get_favourite_model.dart';
import '../../../../controllers/favourite_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_network_image.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class PostCard extends StatefulWidget {
  final FavouriteDataList fav; // <-- Correct model

  const PostCard({
    super.key,
    required this.fav,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isDescriptionExpanded = false;
  final FavouriteController controller = Get.find();

  void _toggleDescription() {
    setState(() {
      isDescriptionExpanded = !isDescriptionExpanded;
    });
  }

  void _removeFavourite(String favId) async {
    await controller.removeFavourite(favId);
    // Optionally show a SnackBar or setState if needed
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final fav = widget.fav;
    final business = fav.business;

    return Card(
      color: AppColors.fillColor,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================= BUSINESS INFO ==========================
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  CustomNetworkImage(
                    imageUrl: business?.photos?.isNotEmpty == true
                        ? business!.photos!.first.photoUrl ?? ""
                        : "https://placehold.co/200x200",
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
                            CustomText(
                              text: business?.name ?? '',
                              fontSize: 20.sp,
                              maxLine: 2,
                              fontWeight: FontWeight.w700,
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.yellow, size: 20),
                                SizedBox(width: 5),
                                CustomText(
                                  text: business?.rating?.toString() ?? "0",
                                  fontSize: 16.sp,
                                  color: AppColors.greyColor,
                                ),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            CustomText(
                              text: business?.category ?? '',
                              fontSize: 16.sp,
                              color: AppColors.greyColor,
                            ),
                            Spacer(),
                            Icon(Icons.location_on_outlined,
                                color: Colors.grey, size: 20),
                            SizedBox(width: 5.w),
                            CustomText(
                              text: "0.5 km",
                              fontSize: 16.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(width: 8.w),

                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.secondaryButtonColor,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                child: CustomText(text: "Open"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _popupMenuButton(fav.id ?? ''),
                ],
              ),
            ),

            Divider(thickness: 0.3, color: AppColors.greyColor),

            // =================== DESCRIPTION ========================
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: business?.description ?? "No description",
                    color: Colors.white,
                    fontSize: 14,
                    maxLine: isDescriptionExpanded ? 150 : 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  GestureDetector(
                    onTap: _toggleDescription,
                    child: CustomText(
                      text: isDescriptionExpanded ? "Show Less" : "Show More",
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            // =================== IMAGES ======================
            if (business?.photos != null && business!.photos!.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(10.w),
                child: SizedBox(
                  height: 150.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: business.photos!.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, i) {
                      return CustomNetworkImage(
                        imageUrl: business.photos![i].photoUrl ?? "",
                        height: 88.h,
                        width: 150.w,
                        borderRadius: BorderRadius.circular(12.r),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // =================== POPUP MENU ===========================
  PopupMenuButton<int> _popupMenuButton(String favId) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      icon: SvgPicture.asset(AppIcons.dot, color: Colors.white),
      offset: Offset(-10, 15),
      onSelected: (result) {
        if (result == 0) {
          _removeFavourite(favId); // <-- Call delete method
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 0, child: CustomText(text: "Remove Favorite")),
        PopupMenuItem(value: 1, child: CustomText(text: "Block User")),
      ],
      color: AppColors.fillColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
