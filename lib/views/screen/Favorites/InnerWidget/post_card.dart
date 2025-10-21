import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_strings.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_network_image.dart';
import '../../../base/custom_text.dart';
import '../../../base/custom_text_field.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

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
    return Card(
      color: AppColors.fillColor,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //=========================> Name and Image Poster <======================
            Row(
              children: [
                CustomNetworkImage(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKbe4FsXoLVUtq5YPBCHgiSX4Owqshk79Ejw&s',
                  height: 64.h,
                  width: 64.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Nura',
                        fontSize: 20.sp,
                        textAlign: TextAlign.start,
                        maxLine: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: '25 Aug 2024',
                        fontSize: 16.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
                _popupMenuButton()
              ],
            ),
            Divider(thickness: 0.3, color: AppColors.greyColor),

            //=========================> Restaurant Info <======================
            Padding(
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
                            CustomText(
                              text: 'Motin miar Pizza Ghar',
                              fontSize: 20.sp,
                              textAlign: TextAlign.start,
                              maxLine: 2,
                              fontWeight: FontWeight.w700,
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow, size: 20),
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
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                child: CustomText(text: AppStrings.open.tr),
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

            //=====================> Description with "More" Button <======================
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: isDescriptionExpanded
                        ? 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
                        : 'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
                    color: Colors.white,
                    fontSize: 14,
                    maxLine: isDescriptionExpanded ? 150 : 2,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: _toggleDescription,
                    child: CustomText(
                      text: isDescriptionExpanded ? 'Show Less' : 'Show More',
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            //=====================> Image Carousel <======================
            Padding(
              padding: EdgeInsets.all(10.w),
              child: SizedBox(
                height: 150.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CustomNetworkImage(
                      imageUrl:
                          'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                      height: 88.h,
                      width: 150.w,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    SizedBox(width: 8.w),
                    CustomNetworkImage(
                      imageUrl:
                          'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                      height: 88.h,
                      width: 150.w,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    SizedBox(width: 8.w),
                    CustomNetworkImage(
                      imageUrl:
                          'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                      height: 88.h,
                      width: 150.w,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //================================> Popup Menu Button Method <=============================
  PopupMenuButton<int> _popupMenuButton() {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      icon: SvgPicture.asset(AppIcons.dot, color: Colors.white),
      surfaceTintColor: AppColors.fillColor,
      offset: Offset(-10, 15),
      onSelected: (int result) {
        print(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          onTap: (){
            //Remove method call here
          },
          value: 0,
          child: CustomText(
           text:  'Remove Favorite'.tr,
          ),
        ),
        PopupMenuItem<int>(
          onTap: (){
            //Block method call here
          },
          value: 1,
          child: CustomText(
           text:  'Block User'.tr,
          ),
        ),
      ],
      color: AppColors.fillColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
