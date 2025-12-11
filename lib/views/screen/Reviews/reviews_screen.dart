import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import '../../../controllers/user_review_controller.dart';
import '../../base/custom_text.dart';

import 'dart:io';

class ReviewsScreen extends StatelessWidget {
  final ReviewController controller = Get.put(ReviewController());

  ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: controller.businessName,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),

        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⭐ RATING SECTION
                  Center(
                    child: Obx(() => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => controller.rating.value = index + 1,
                          child: Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons.star_border,
                            color: index < controller.rating.value
                                ? Colors.amber
                                : Colors.grey[600],
                            size: 32.w,
                          ),
                        );
                      }),
                    )),
                  ),

                  SizedBox(height: 16.h),
                  Center(
                    child: CustomText(
                      text: 'No Reviews',
                      color: AppColors.greyColor,
                      fontSize: 16.sp,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // TITLE
                  TextFormField(
                    controller: controller.titleCtrl,
                    decoration: inputDecoration('Title*'),
                    validator: (v) => v!.isEmpty ? "Title is required" : null,
                    style: const TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 16.h),

                  // DESCRIPTION
                  TextFormField(
                    controller: controller.descCtrl,
                    maxLines: 3,
                    decoration: inputDecoration('Description*'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Description is required";
                      }
                      if (v.trim().length < 10) {
                        return "Description must be at least 10 characters";
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),


                  SizedBox(height: 16.h),

                  // ⭐ ADD PHOTO
                  Row(
                    children: [
                      CustomText(
                        text: "Add Photo",
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        right: 4.w,
                      ),
                      CustomText(text: "(optional)", fontSize: 12.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // IMAGE PICKER BOX
                  Obx(() {
                    final photo = controller.selectedPhoto.value;
                    return GestureDetector(
                      onTap: photo == null ? controller.showImagePickerOptions : null,
                      child: Container(
                        width: double.infinity,
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 1.5,
                          ),
                        ),
                        child: photo == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                color: Colors.grey[600], size: 32.w),
                            SizedBox(height: 8.h),
                            CustomText(
                              text: "Tap to add photo",
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                            ),
                          ],
                        )
                            : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.file(
                                File(photo.path),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: controller.removePhoto,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  SizedBox(height: 16.h),

                  // WHAT YOU LIKED
                  Row(
                    children: [
                      CustomText(
                        text: "What You Liked",
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        right: 4.w,
                      ),
                      CustomText(text: "(up to 3, optional)", fontSize: 12.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ...List.generate(
                    3,
                        (i) => buildTextField(controller.likedCtrls[i], '${i + 1}.'),
                  ),

                  SizedBox(height: 24.h),

                  // WHAT YOU DIDN'T LIKE
                  Row(
                    children: [
                      CustomText(
                        text: "What You Didn’t Like",
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        right: 4.w,
                      ),
                      CustomText(text: "(up to 2, optional)", fontSize: 12.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ...List.generate(
                    2,
                        (i) => buildTextField(controller.dislikedCtrls[i], '${i + 1}.'),
                  ),

                  SizedBox(height: 32.h),

                  // ⭐ SUBMIT BUTTON
                  Obx(() {
                    return
                      CustomButton(
                        onTap: controller.isUploadingPhoto.value
                            ? () {}
                            : () => controller.submitReview(),
                        loading: controller.isUploadingPhoto.value,
                        text: controller.isUploadingPhoto.value ? "Uploading..." : AppStrings.post.tr,
                      );

                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: AppColors.fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: Colors.orange),
      ),
    );
  }



  Widget buildTextField(TextEditingController controller, String prefix) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixText: "$prefix ",
          prefixStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: AppColors.fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
