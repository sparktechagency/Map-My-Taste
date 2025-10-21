import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../base/custom_network_image.dart';
import '../../../base/custom_text.dart';

class TrendingPlaceCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final String time;

  TrendingPlaceCard({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.fillColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imageUrl,
            height: 180.h, width: 300.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text(
                      '$rating',
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                        Text(
                          time,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}