import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_list_tile.dart';
import '../../../base/custom_text.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Selected filters
  String? selectedCategory;
  bool isOpenNow = false;
  bool isVerified = false;
  double minRating = 0;

  // Static categories
  final List<Map<String, dynamic>> staticCategories = [
    {'icon': Icons.restaurant, 'label': 'Restaurant', 'type': 'restaurant'},
    {'icon': Icons.hotel, 'label': 'Hotel', 'type': 'hotel'},
    {'icon': Icons.church, 'label': 'Church', 'type': 'church'},
    {'icon': Icons.local_cafe, 'label': 'Cafe', 'type': 'cafe'},
    {'icon': Icons.bakery_dining, 'label': 'Bakery', 'type': 'bakery'},
    {'icon': Icons.bar_chart, 'label': 'Bar', 'type': 'bar'},
  ];


  String? _getCategoryType(String? label) {
    if (label == null) return null;
    try {
      return staticCategories
          .firstWhere((e) => e['label'] == label)['type'] as String;
    } catch (e) {
      return null; // Handle case where label is not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 100.w,
                    child: Divider(thickness: 3.9, color: AppColors.greyColor),
                  ),
                ),
                SizedBox(height: 48.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Filter'.tr,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      bottom: 16.h,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.cancel_outlined,
                        color: AppColors.greyColor,
                        size: 32.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                //=======================> Category Dropdown <==================
                CustomText(
                  text: 'Category'.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),
                _dropdownField(
                  staticCategories.map((e) => e['label'].toString()).toList(),
                  selectedCategory,
                      (value) => setState(() => selectedCategory = value),
                  'Select Category'.tr,
                ),
                SizedBox(height: 24.h),

                //=======================> Minimum Rating Slider <==================
                CustomText(
                  text: 'Minimum Rating'.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),
                Slider(
                  value: minRating,
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: minRating.toStringAsFixed(1),
                  activeColor: AppColors.primaryColor,
                  inactiveColor: AppColors.greyColor,
                  onChanged: (value) {
                    setState(() => minRating = value);
                  },
                ),
                SizedBox(height: 16.h),

                //=======================> Open Now Switch <==================
                CustomListTile(
                  title: 'Open Now'.tr,
                  suffixIcon: Switch(
                    value: isOpenNow,
                    onChanged: (value) => setState(() => isOpenNow = value),
                    activeColor: AppColors.primaryColor,
                    inactiveThumbColor: AppColors.greyColor,
                    inactiveTrackColor: AppColors.fillColor,
                  ),
                ),
                SizedBox(height: 16.h),

                //=======================> Is Verified Switch <==================
                CustomListTile(
                  title: 'Verified'.tr,
                  suffixIcon: Switch(
                    value: isVerified,
                    onChanged: (value) => setState(() => isVerified = value),
                    activeColor: AppColors.primaryColor,
                    inactiveThumbColor: AppColors.greyColor,
                    inactiveTrackColor: AppColors.fillColor,
                  ),
                ),
                SizedBox(height: 24.h),

                //====================> Apply Filter Button <=====================
                CustomButton(
                  onTap: () {
                    // CRITICAL: Check if the validation is failing and preventing Get.back()
                    // If you have no validators, this should always be true.
                    if (_formKey.currentState!.validate()) {

                      final categoryType = _getCategoryType(selectedCategory);

                      // ⭐️ DEBUG STEP: Log value before closing sheet ⭐️
                      log('Filter Sheet: Closing with category: $categoryType');

                      Get.back(result: {
                        'category': categoryType, // This can be null if nothing was selected
                        'minRating': minRating,
                        'openNow': isOpenNow,
                        'isVerified': isVerified,
                      });
                    } else {
                      log('Filter Sheet: Form validation failed!'); // Check if this logs
                    }
                  },
                  text: 'Apply Filter'.tr,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //============================> Dropdown Field <===============================
  Widget _dropdownField(
      List<String> options,
      String? selectedValue,
      Function(String?) onChanged,
      String hint,
      ) {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.fillColor,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      items: options
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e, style: const TextStyle(color: Colors.white)),
      ))
          .toList(),
      onChanged: onChanged,
      value: selectedValue,
      hint: Text(hint, style: TextStyle(fontSize: 16.sp, color: Colors.white)),
    );
  }
}
