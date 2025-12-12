import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import '../../../../helpers/prefs_helpers.dart';
import '../../../../helpers/route.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import '../../../../utils/app_icons.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_list_tile.dart';
import '../../../base/custom_text.dart';

class DrawerSection extends StatefulWidget {
  DrawerSection({super.key});

  @override
  State<DrawerSection> createState() => _DrawerSectionState();
}

class _DrawerSectionState extends State<DrawerSection> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 286.w,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 44.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=====================================>  Settings Row <=============================
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(width: 12.w),
                  CustomText(
                    text: AppStrings.settings.tr,
                    fontWeight: FontWeight.w700,
                    fontSize: 22.sp,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Divider(thickness: 0.5),
              SizedBox(height: 24.h),
              CustomText(
                text: AppStrings.accountCenter.tr,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                bottom: 12.h,
              ),
              //=====================================>  Edit Profile  ListTile <=============================
              CustomListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.editProfileScreen);
                },
                title: AppStrings.editProfile.tr,
                borderColor: AppColors.fillColor,
                prefixIcon: SvgPicture.asset(AppIcons.editProfile),
              ),
              //=====================================>  Password ListTile <=============================
              CustomListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.changePasswordScreen);
                },
                title: AppStrings.password.tr,
                prefixIcon: SvgPicture.asset(AppIcons.lock),
              ),
              Divider(thickness: 0.5),
              SizedBox(height: 24.h),
              //=====================================>  Help & Support  ListTile <=============================
              CustomText(
                text: AppStrings.helpSupport.tr,
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                bottom: 12.h,
              ),
              //=====================================>  Report a problem  ListTile <=============================
              CustomListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.reportProblemScreen);
                },
                title: AppStrings.reportProblem.tr,
                prefixIcon: SvgPicture.asset(AppIcons.report),
              ),
              //=====================================>  Terms & Policies  ListTile <=============================
              CustomListTile(
                onTap: () {
                  Get.toNamed(AppRoutes.termsPoliciesScreen);
                },
                title: AppStrings.termsPolicies.tr,
                prefixIcon: SvgPicture.asset(AppIcons.terms),
              ),
              Divider(thickness: 0.5),
              SizedBox(height: 16.h),
              //====================================> LogOut Section <====================================
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 26.h,
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: 'Are you sure you want to sign out?'.tr,
                              fontSize: 16.sp,
                              maxLine: 2,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 120.w,
                                  height: 40.h,
                                  child: CustomButton(
                                    text: 'No'.tr,
                                    fontSize: 16.h,
                                    onTap: () {
                                      Get.back();
                                    },
                                    color: Colors.white,
                                    textColor: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 120.w,
                                  height: 40.h,
                                  child: CustomButton(
                                    text: 'Yes'.tr,
                                    fontSize: 16.h,
                                    onTap: () async  {
                                       await PrefsHelper.remove(AppConstants.isLogged);
                                                await PrefsHelper.remove(AppConstants.id);
                                                await PrefsHelper.remove(AppConstants.bearerToken);
                                               // _authController.googleSignIn.signOut();
                                      Get.offAllNamed(AppRoutes.signInScreen);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        elevation: 12.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            width: 1.w,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CustomListTile(
                  title: AppStrings.signOut.tr,
                  borderColor: AppColors.fillColor,
                  prefixIcon: SvgPicture.asset(AppIcons.signOut),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
