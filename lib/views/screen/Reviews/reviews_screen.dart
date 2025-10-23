import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import '../../base/custom_text.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _likedControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _dislikedControllers = List.generate(
    2,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _likedControllers) {
      controller.dispose();
    }
    for (var controller in _dislikedControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitReview() {
    if (_formKey.currentState?.validate() == true && _rating > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill required fields and select a rating.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'Motin Miar Pizza Ghur',
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating Section
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: index < _rating
                                ? Colors.amber
                                : Colors.grey[600],
                            size: 32.w,
                          ),
                        );
                      }),
                    ),
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
                  // Title Field
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title*',
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.h),
                  //==================================> Description Field <======================
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description*',
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 24.h),
                  //=============================> What You Liked Section <==============================
                  Row(
                    children: [
                      CustomText(
                        text: 'What You Liked',
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        right: 4.w,
                      ),
                      CustomText(text: '(up to 3, optional)', fontSize: 12.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ...List.generate(
                    3,
                    (i) => _buildTextField(_likedControllers[i], '${i + 1}.'),
                  ),
                  SizedBox(height: 24.h),
                  //=============================> What You Didn't Like Section <=============================
                  Row(
                    children: [
                      CustomText(
                        text: 'What You Didn’t Like',
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        right: 4.w,
                      ),
                      CustomText(text: '(up to 2, optional)', fontSize: 12.sp),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ...List.generate(
                    2,
                    (i) =>
                        _buildTextField(_dislikedControllers[i], '${i + 1}.'),
                  ),
                  SizedBox(height: 32.h),
                  //======================================> Post Button <===============================
                  CustomButton(onTap: _submitReview, text: AppStrings.post.tr),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //======================================> Post Button <===============================
  Widget _buildTextField(TextEditingController controller, String prefix) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixText: '$prefix ',
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
