import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors{
  
  static Color primaryColor=const Color(0xFFFF4F0F);
  static Color secondaryButtonColor=const Color(0xFF1DAD00);
  static Color backgroundColor=const Color(0xFF111111);
  static Color cardColor = const Color(0xFF2F2F2F);
  static Color cardLightColor = const Color(0xFF555555);
  static Color borderColor = const Color(0xFFFF4F0F);
  static Color textColor = const Color(0xFFFEFEFE);
  static Color bottomMenuColor = const Color(0xFF6B2106);
  static Color subTextColor = const Color(0xFFE8E8E8);
  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color hintColor = const Color(0xFFB5B5B5);
  static Color greyColor = const Color(0xFF848484);
  static Color secondaryGreyColor = const Color(0xFF1E1E1E);
  static Color fillColor = const Color(0xFF272727);
  static Color dividerColor = const Color(0xFF555555);
  static Color shadowColor = const Color(0xFF2B2A2A);
  static Color bottomBarColor = const Color(0xFF343434);

  static BoxShadow shadow=BoxShadow(
    blurRadius: 4,
    spreadRadius: 0,
    color: shadowColor,
    offset: const Offset(0, 2),
  );
}