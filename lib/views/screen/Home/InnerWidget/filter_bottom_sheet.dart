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
  double _maxDistance = 36;
  double _maxRating = 1;
  double _minPrice = 500;
  double _maxPrice = 2500;
  String? selectedGender;
  String? selectedMatch;
  bool isSwitched = false;

  final List<String> genderOptions = [
    'Restaurants',
    'Hotel',
    'Things',
    'Museums',
    'Pharmacies',
    'Parks',
    'Hospital',
    'Juice Bar',
    'Spa',
  ];

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
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: AppColors.greyColor,
                        size: 32.w,
                      ),
                    ),
                  ],
                ),
                //=======================> Category Dropdown <==================
                CustomText(
                  text: 'Category'.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  bottom: 8.h,
                ),
                _dropdownField(genderOptions, selectedGender, (value) {
                  setState(() {
                    selectedGender = value;
                  });
                }, 'Category'.tr),
                SizedBox(height: 16.h),
                //=======================> Distance Slider <==================
                CustomText(
                  text: 'Distance'.tr,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  bottom: 12.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _distanceSlider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Distance'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            _maxDistance.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                //=======================> Age Range Slider <==================
                CustomText(
                  text: 'Price Range'.tr,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _priceSlider(),
                    _rangeLabels('Minimum', _minPrice, 'Maximum', _maxPrice),
                  ],
                ),
                SizedBox(height: 24.h),
                //=======================> Minimum Rating Slider <==================
                CustomText(
                  text: 'Minimum Rating'.tr,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  bottom: 12.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ratingSlider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Rating'.tr,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            _maxRating.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                //=======================> Open Now Row <==================
                CustomListTile(
                  title: 'Open Now'.tr,
                  suffixIcon: Switch(
                    padding: EdgeInsets.zero,
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeColor: AppColors.primaryColor,
                    inactiveThumbColor: AppColors.greyColor,
                    inactiveTrackColor: AppColors.fillColor,
                  ),
                ),
                SizedBox(height: 24.h),
                //====================> Apply Filter Button <=====================
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
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

  //============================> Distance Slider <===============================
  Widget _distanceSlider() {
    return Slider(
      activeColor: AppColors.primaryColor,
      inactiveColor: AppColors.greyColor,
      value: _maxDistance,
      min: 0,
      max: 100,
      divisions: 100,
      label: _maxDistance.toStringAsFixed(0),
      onChanged: (value) {
        setState(() {
          _maxDistance = value;
        });
      },
    );
  }

  //============================> rating Slider <===============================
  Widget _ratingSlider() {
    return Slider(
      activeColor: AppColors.primaryColor,
      inactiveColor: AppColors.greyColor,
      value: _maxRating,
      min: 0,
      max: 5,
      divisions: 5,
      label: _maxRating.toStringAsFixed(0),
      onChanged: (value) {
        setState(() {
          _maxRating = value;
        });
      },
    );
  }

  //============================> Price Slider <===============================
  Widget _priceSlider() {
    return RangeSlider(
      activeColor: AppColors.primaryColor,
      inactiveColor: AppColors.greyColor,
      values: RangeValues(_minPrice, _maxPrice),
      min: 500,
      max: 2500,
      divisions: 100,
      labels: RangeLabels(
        _minPrice.toStringAsFixed(0),
        _maxPrice.toStringAsFixed(0),
      ),
      onChanged: (values) {
        setState(() {
          _minPrice = values.start;
          _maxPrice = values.end;
        });
      },
    );
  }

  //============================> Dropdown Field <===============================
  _dropdownField(
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      items: options
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      hint: Text(
        hint,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  //============================> Range Labels <===============================
  Widget _rangeLabels(
    String label1,
    double value1,
    String label2,
    double value2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_rangeTag(label1, value1), _rangeTag(label2, value2)],
    );
  }

  Widget _rangeTag(String label, double value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryColor, width: 1.w),
          ),
          child: Text(
            value.toStringAsFixed(0),
            style: TextStyle(fontSize: 14.sp, color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
