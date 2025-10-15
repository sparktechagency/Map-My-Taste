import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../base/custom_app_bar.dart';

class ReportProblemScreen extends StatelessWidget {
  ReportProblemScreen({super.key});
  final TextEditingController descriptionCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppStrings.reportProblem.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              //==================================> Description TextField <====================
              CustomTextField(
                controller: descriptionCTRL,
                hintText: AppStrings.describeTheProblem.tr,
                maxLines: 5,
              ),
              SizedBox(height: 341.h),
              //==================================> Send It Button <====================
              CustomButton(onTap: () {}, text: AppStrings.sendIt),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
