import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, this.title});

  var title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios)),
      title:
          CustomText(text: title, fontSize: 16.sp, fontWeight: FontWeight.bold),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
