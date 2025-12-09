import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_my_taste/utils/app_colors.dart';

class CustomTab extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback? onTap;

  const CustomTab({
    super.key,
    this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? iconWidget;

    if (icon is IconData) {
      iconWidget = Icon(icon, color: Colors.white, size: 18);
    } else if (icon is String) {
      iconWidget = Text(icon, style: const TextStyle(fontSize: 18));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.fillColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                label.trim().replaceAll(RegExp(r'\s+'), ' '),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (iconWidget != null)
              Align(
                alignment: Alignment.centerLeft,
                child: iconWidget,
              ),
          ],
        ),
      ),
    );
  }
}
