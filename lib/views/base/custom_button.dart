import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/views/base/custom_text.dart';
import '../../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.color,
      this.textColor,
      this.broderColor,
      this.textStyle,
      this.padding = EdgeInsets.zero,
      required this.onTap,
      required this.text,
      this.loading = false,
      this.width,
      this.fontSize,
      this.height});
  final Function() onTap;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Color? broderColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: ElevatedButton(
          onPressed: loading ? () {} : onTap,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.w, color: broderColor ?? AppColors.borderColor),
                borderRadius: BorderRadius.circular(16.r)),
            backgroundColor: color ?? AppColors.primaryColor,
            minimumSize: Size(width ?? Get.width, height ?? 53.h),
          ),
          child: loading
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : CustomText(
                  text: text,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize ?? 16.sp,
                  color: textColor ?? Colors.white),
        ));
  }
}
