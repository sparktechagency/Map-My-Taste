import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/models/get_favourite_model.dart';
import '../../../../controllers/favourite_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_expandable_text.dart';
import '../../../base/custom_image_gallery.dart';
import '../../../base/custom_network_image.dart';
import '../../../base/custom_text.dart';

class PostCard extends StatefulWidget {
  final FavouriteDataList fav;
  const PostCard({super.key, required this.fav});

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
            Row(
              children: [
                CustomNetworkImage(
                  imageUrl: business?.photos?.isNotEmpty == true
                      ? business!.photos!.first.photoUrl ?? ""
                      : "https://placehold.co/200x200",
                  height: 68.h,
                  width: 74.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ======================= BUSINESS Name and Review Row ==========================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomText(
                              text: business?.name ?? '',
                              fontSize: 18.sp,
                              textAlign: TextAlign.start,
                              textOverflow: TextOverflow.ellipsis,
                              maxLine: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          _popupMenuButton(fav.id ?? ''),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: business?.category?.capitalize ?? '',
                            fontSize: 16.sp,
                            color: AppColors.greyColor,
                          ),
                          SizedBox(width: 12.w),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              SizedBox(width: 5),
                              CustomText(
                                text: business?.rating?.toString() ?? "0",
                                fontSize: 16.sp,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: (business?.businessHours?.isOpen ?? false)
                                  ? Colors.green
                                  : Colors.amber,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              child: CustomText(
                                text: (business?.businessHours?.isOpen ?? false)
                                    ? AppStrings.open.tr
                                    : AppStrings.close.tr,
                                color: Colors.white, // make text readable
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
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
            SizedBox(height: 8.h),
            // ======================= Review and Location Row ==========================
            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                SizedBox(width: 5.w),
                Flexible(
                  child: CustomText(
                    text: business?.location?.address?.formattedAddress ?? '',
                    maxLine: 3,
                    fontSize: 16.sp,
                    color: AppColors.greyColor,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Divider(thickness: 0.3, color: AppColors.greyColor),
            // =================== DESCRIPTION ========================
            Padding(
              padding: EdgeInsets.all(10.w),
              child: ExpandableText(
                text: business?.description ?? "No description",
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                toggleStyle: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
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
                      final url = business.photos?[i].photoUrl ?? '';
                      return GestureDetector(
                        onTap: () => CustomImageGallery.show(
                          context,
                          business.photos!
                              .map((e) => e.photoUrl ?? '')
                              .toList(),
                          initialIndex: i,
                        ),
                        child: CustomNetworkImage(
                          imageUrl: url,
                          height: 88.h,
                          width: 150.w,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
          _removeFavourite(favId);
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 0, child: CustomText(text: "Remove Favorite")),
      ],
      color: AppColors.fillColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
