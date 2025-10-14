import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacrter;
  final Color? filColor;
  final Color? borderColor;
  final int? maxLines;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contenpaddingHorizontal;
  final double? contenpaddingVertical;
  final Widget? suffixIcons;
  final FormFieldValidator? validator;
  final VoidCallback? onTab;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;

  const CustomTextField({
    super.key,
    this.contenpaddingHorizontal,
    this.contenpaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcons,
    this.validator,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscureCharacrter = '*',
    this.filColor,
    this.borderColor,
    this.maxLines = 1,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.onTab,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      onTap: widget.onTab,
      readOnly: widget.readOnly!,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscureCharacrter!,
      validator: widget.validator,
/*validator: widget.validator ??
              (value) {
            if (widget.isEmail == null) {
              if (value!.isEmpty) {
                return "Please enter ${widget.hintText!.toLowerCase()}";
              } else if (widget.isPassword) {
                bool data = AppConstants.passwordValidator.hasMatch(value);
                if (value.isEmpty) {
                  return "Please enter ${widget.hintText!.toLowerCase()}";
                } else if (!data) {
                  return "Insecure password detected.";
                }
              }
            } else {
              bool data = AppConstants.emailValidator.hasMatch(value!);
              if (value.isEmpty) {
                return "Please enter ${widget.hintText!.toLowerCase()}";
              } else if (!data) {
                return "Please check your email!";
              }
            }
            return null;
          },*/

      cursorColor: AppColors.primaryColor,
      obscureText: widget.isPassword ? obscureText : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: widget.contenpaddingHorizontal ?? 12.w,
            vertical: widget.contenpaddingVertical ?? 16.w),
        filled: true,
        fillColor: widget.filColor ?? AppColors.fillColor,
        prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: widget.prefixIcon),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: toggle,
                child: _suffixIcon(
                    obscureText ? AppIcons.eyeOffIcon : AppIcons.eyeIcon),
              )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: widget.suffixIcons,
        ),
        prefixIconConstraints: BoxConstraints(minHeight: 24.h, minWidth: 24.w),
        suffixIconConstraints: BoxConstraints(minHeight: 24.h, minWidth: 24.w),
        errorStyle: const TextStyle(color: Colors.red),
        suffixIconColor: AppColors.greyColor,
        prefixIconColor: AppColors.greyColor,
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: AppColors.hintColor, fontFamily: 'Arial'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1.w,
            color: AppColors.primaryColor,
          ),
        ),
        errorBorder: _buildOutlineInputBorder(),
        focusedBorder: _buildFocusedBorder(),
        enabledBorder: _buildOutlineInputBorder(),
        disabledBorder: _buildOutlineInputBorder(),
      ),
    );
  }

  _suffixIcon(String icon) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: SvgPicture.asset(
        icon,
        color: Colors.grey,
      ),
    );
  }

  _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        width: 1.w,
        color: widget.borderColor ?? AppColors.fillColor,
      ),
    );
  }
  _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        width: 1.w,
        color: widget.borderColor ?? AppColors.primaryColor,
      ),
    );
  }
}
