import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

ThemeData light({Color color = const Color(0xFFFFFFFF)}) => ThemeData(
  fontFamily: 'Montserrat',
  primaryColor: color,
  scaffoldBackgroundColor: Colors.transparent,
  secondaryHeaderColor: AppColors.textColor,
  disabledColor: AppColors.subTextColor,
  brightness: Brightness.dark,
  hintColor: AppColors.hintColor,
  cardColor: AppColors.cardColor,
  dividerColor: AppColors.dividerColor,
  shadowColor: AppColors.shadowColor,
  canvasColor: AppColors.bottomBarColor,
  unselectedWidgetColor: Colors.red,

  inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fillColor,
      hintStyle: TextStyle(color: AppColors.hintColor, fontSize: 16.sp),
      isDense: true,
      contentPadding:
      EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      enabledBorder: enableBorder(),
      focusedBorder: focusedBorder(),
      errorBorder: errorBorder()),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.backgroundColor,
    unselectedItemColor: AppColors.backgroundColor,
    selectedLabelStyle: TextStyle(color: color),
    unselectedLabelStyle: const TextStyle(color: Colors.red),
  ),
  appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          fontFamily: 'Open Sans',
          color: AppColors.textColor),
      iconTheme: IconThemeData(color: AppColors.borderColor)),
  iconTheme: IconThemeData(color: AppColors.borderColor),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
      side: BorderSide(color: Colors.black), // Inactive border color
    ),
  ),
  textTheme: TextTheme(
    bodySmall: TextStyle(color: AppColors.textColor),
    bodyLarge: TextStyle(color: AppColors.textColor),
    bodyMedium: TextStyle(color: AppColors.textColor),
  ).apply(
    bodyColor: AppColors.textColor,
    displayColor: AppColors.subTextColor,
  ), textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: color)),
  colorScheme: ColorScheme.dark(primary: color, secondary: color)
      .copyWith(background: Color(0xFF343636))
      .copyWith(error: Color(0xFFdd3135)),
);

OutlineInputBorder enableBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(
      color: AppColors.primaryColor,
    ),
  );
}

OutlineInputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(
      color: AppColors.primaryColor,
    ),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(
      color: Colors.red,
    ),
  );
}
