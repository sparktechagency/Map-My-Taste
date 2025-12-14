import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_network_image.dart';
import 'package:map_my_taste/views/screen/Profile/InnerWidget/drawer_section.dart';
import '../../../controllers/profile_controller.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import '../../base/bottom_menu..dart';
import '../../base/custom_button.dart';
import '../../base/custom_page_loading.dart';
import '../../base/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = Get.put(ProfileController());

  @override
  void initState() {
    _controller.getProfileData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerSection(),
      bottomNavigationBar: BottomMenu(4),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppStrings.profile.tr,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
              /* InkWell(
                onTap: (){ _controller.scaffoldKey.currentState!.openEndDrawer();},
                  child: SvgPicture.asset(AppIcons.settings)),*/
            ],
          ),
        ),
        toolbarHeight: 70.h,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Obx(() {
          if (_controller.profileLoading.value) {
            return Center(child: CustomPageLoading());
          }
          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    //========================> Profile Image <=============================
                    CustomNetworkImage(
                      imageUrl: _controller.profileModel.value.profile?.profilePicture?.url ?? '',
                      height: 120.h,
                      width: 120.w,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        width: 1.w,
                        color: AppColors.greyColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    //========================> Profile Name <=============================
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //========================> Profile Name <=============================
                          CustomText(
                            text:
                                _controller.profileModel.value.fullName ??
                                "Loading...",
                            fontSize: 22.sp,
                            maxLine: 3,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w700,
                            textOverflow: TextOverflow.ellipsis,
                            bottom: 4.h,
                          ),
                          //========================> Profile Email <=============================
                          CustomText(
                            text:
                                _controller.profileModel.value.email ??
                                "Loading...",
                            fontSize: 16.sp,
                            maxLine: 3,
                            textAlign: TextAlign.start,
                            color: AppColors.greyColor,
                            textOverflow: TextOverflow.ellipsis,
                            bottom: 14.h,
                          ),
                          //========================> Post Friends Column <=============================
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start,
                            children: [
                              _commonPosts(
                                '${_controller.profileModel.value.stats?.numberOfPosts ?? "0"}',
                                AppStrings.posts.tr,
                              ),
                              // _commonPosts(
                              //   '${_controller.profileModel.value.stats?.numberOfFriends ?? "0"}',
                              //   AppStrings.friends.tr,
                              // ),
                              // _commonPosts(
                              //   '${_controller.profileModel.value.stats?.numberOfFollowers ?? "0"}',
                              //   AppStrings.followers.tr,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _commonPlace(
                      SvgPicture.asset(AppIcons.location),
                      '${_controller.profileModel.value.stats?.numberOfPlacesVisited ?? "0"}',
                      AppStrings.placeVisited.tr,
                    ),
                    _commonPlace(
                      SvgPicture.asset(AppIcons.favorites),
                      '${_controller.profileModel.value.stats?.numberOfFavorites ?? "0"}',
                      AppStrings.favorites.tr,
                    ),
                    _commonPlace(
                      SvgPicture.asset(AppIcons.star),
                      '${_controller.profileModel.value.stats?.numberOfReviews ?? "0"}',
                      AppStrings.reviewsWritten.tr,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  //========================> Common Post Friends Column <=============================
  Container _commonPosts(String number, title) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(8.r),
        // border: Border.all(width: 1.w, color: AppColors.greyColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            //========================> Profile Name <=============================
            CustomText(
              text: number,
              fontSize: 22.sp,
              maxLine: 3,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
              textOverflow: TextOverflow.ellipsis,
              bottom: 4.h,
            ),
            //========================> Profile Email <=============================
            CustomText(
              text: title,
              fontSize: 16.sp,
              maxLine: 3,
              textAlign: TextAlign.start,
              color: AppColors.greyColor,
              textOverflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  //========================> Common Place Visited Column <=============================
  Container _commonPlace(Widget icon, String num, title) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fillColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            icon,
            SizedBox(height: 8.h),
            CustomText(text: num, fontSize: 18.sp, fontWeight: FontWeight.w700),
            SizedBox(height: 8.h),
            CustomText(
              text: title,
              fontSize: 16.sp,
              maxLine: 3,
              textAlign: TextAlign.start,
              color: AppColors.greyColor,
              textOverflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  //===============================> Log Out Bottom Sheet <===============================
  _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppColors.cardColor,
          ),
          height: 265,
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Logout',
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
              ),
              SizedBox(height: 20.h),
              Divider(
                thickness: 1,
                color: AppColors.primaryColor,
                indent: 15.w,
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: 'Are you sure you want to log out?',
                fontSize: 16.sp,
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: 115.w,
                    height: 27.h,
                    onTap: () {
                      Get.back();
                    },
                    text: "No",
                    fontSize: 10.sp,
                    color: Colors.white,
                    textColor: AppColors.primaryColor,
                  ),
                  SizedBox(width: 16.w),
                  CustomButton(
                    width: 115.w,
                    height: 27.h,
                    fontSize: 10.sp,
                    onTap: () {
                      Get.offAllNamed(AppRoutes.homeScreen);
                    },
                    text: "Yes",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //====================================> Pick Image Gallery and Camera <====================
  void _showImagePickerOption() {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              //=========================> Pick Image Gallery <==================
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // _controller.pickImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        size: 50.w,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Gallery',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
              //=========================> Pick Image Camera <====================
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // _controller.pickImage(ImageSource.camera);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50.w,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Camera',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
