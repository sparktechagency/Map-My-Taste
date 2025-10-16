import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../../controllers/profile_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_strings.dart';
import '../../base/custom_network_image.dart';
import '../../base/custom_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

final ProfileController _controller = Get.put(ProfileController());

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
          ),
          child: CustomText(
            text: AppStrings.editProfile.tr,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        toolbarHeight: 70.h,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    //==============================> Profile picture section <=======================
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomNetworkImage(
                          imageUrl:
                              'https://t4.ftcdn.net/jpg/02/24/86/95/360_F_224869519_aRaeLneqALfPNBzg0xxMZXghtvBXkfIA.jpg',
                          height: 120.h,
                          width: 120.w,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            width: 2.w,
                            color: AppColors.greyColor,
                          ),
                        ),
                        //==============================> Edit Profile Button <=======================
                        Positioned(
                          right: -10.w,
                          bottom: -10.h,
                          child: InkWell(
                            onTap: () {
                              _showImagePickerOption();
                            },
                            child: SvgPicture.asset(AppIcons.edit),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    //==============================> Name Controller  <=======================
                    CustomTextField(
                      controller: _controller.fullNameCTRL,
                      labelText: AppStrings.fullName.tr,
                    ),
                    SizedBox(height: 16.h),
                    //==============================> Phone Number Controller  <=======================
                    CustomTextField(
                      controller: _controller.phoneCTRL,
                      labelText: AppStrings.phoneNumber.tr,
                    ),
                    SizedBox(height: 16.h),
                    //==============================> Address Controller  <=======================
                    CustomTextField(
                      controller: _controller.addressCTRL,
                      labelText: AppStrings.address.tr,
                    ),
                    SizedBox(height: 16.h),
                    //==============================> Gender Controller  <=======================
                    CustomTextField(
                      controller: _controller.genderCTRL,
                      labelText: AppStrings.gender.tr,
                    ),
                    SizedBox(height: 245.h),
                    CustomButton(onTap: () {}, text: AppStrings.save.tr),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
                    _controller.pickImage(ImageSource.gallery);
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
                    _controller.pickImage(ImageSource.camera);
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
