import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import 'package:get/get.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_network_image.dart';
import '../../../base/custom_text.dart';
import 'package:map_my_taste/models/search_model.dart';

class PostCard extends StatefulWidget {
  final Business business;
  const PostCard({super.key, required this.business});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isDescriptionExpanded = false;

  void _toggleDescription() {
    setState(() {
      isDescriptionExpanded = !isDescriptionExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final business = widget.business;

    return Card(
      color: AppColors.fillColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Info
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(

              children: [
                CustomNetworkImage(
                  imageUrl: business.photos?.isNotEmpty == true
                      ? business.photos!.first.photoUrl
                      : "https://placehold.co/200x200",
                  height: 64.h,
                  width: 64.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(

                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: CustomText(
                              text: business.name ?? '',
                              fontSize: 20.sp,
                              maxLine: 2,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              SizedBox(width: 5),
                              CustomText(
                                text: business.rating?.toString() ?? "0",
                                color: AppColors.greyColor,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: business.category ?? '',
                            fontSize: 16.sp,
                            color: AppColors.greyColor,
                          ),
                          Spacer(),
                          Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                          SizedBox(width: 5.w),
                          CustomText(
                            text: business.distance?.toStringAsFixed(1) ?? "0.0", // convert double to String with 1 decimal
                            color: AppColors.greyColor,
                            fontSize: 16.sp,
                          ),

                          SizedBox(width: 8.w),
                          Container(
                            decoration: BoxDecoration(
                              color: (business.businessHours?.isOpen ?? false)
                                  ? Colors.green // ✅ open
                                  : Colors.amber, // ✅ closed
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              child: CustomText(
                                text: (business.businessHours?.isOpen ?? false)
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
          ),


          Divider(thickness: 0.3, color: AppColors.greyColor),

          // Description
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: business.description.isNotEmpty
                      ? business.description
                      : "No description",
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

          // Images
          if (business.photos != null && business.photos!.isNotEmpty)
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
                      imageUrl: business.photos?[i].photoUrl ?? '',
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
    );
  }
}
