import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Optional: Show feedback
   /* ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? 'Added to favorites!' : 'Removed from favorites',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: _isFavorite ? Colors.orange : Colors.grey,
        duration: const Duration(milliseconds: 800),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          //======================> Restaurant Image Header <====================================
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //===============================> App Bar Position <================================
                Positioned(
                  top: 32.h,
                  left: 10.w,
                  right: 10.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite
                              ? AppColors.primaryColor
                              : AppColors.primaryColor,
                          size: 28.w,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                ),
                //===============================> Fast Food Position <================================
                Positioned(
                  bottom: -40,
                  right: 16,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcons.food,
                        width: 56.w,
                        height: 56.h,
                      ),
                      CustomText(text: AppStrings.fastFood.tr, fontSize: 16.sp),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //==========================> Restaurant Info Section <=============================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Motin Miar Pizza Ghur',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                            size: 20.w,
                          );
                        }),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '(10)',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: Colors.green,
                            size: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: 'Open',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey[400],
                            size: 20.w,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(text: '1.2 km'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    text:
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                    fontSize: 16.sp,
                    textAlign: TextAlign.justify,
                    maxLine: 50,
                  ),
                   SizedBox(height: 24.h),
                  //=============================================> Map Container <========================================
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.fillColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        //==================================> Hours Row <========================
                        _buildInfoRow(
                          icon: Icons.access_time,
                          label: 'Hours',
                          value: 'Open until 9:30 pm',
                        ),
                        Divider(color: Colors.grey, height: 1.h, thickness: 0.5),

                        //===========================> Website Row <==============================
                        _buildInfoRow(
                          icon: Icons.language,
                          label: 'Website',
                          value: '',
                        ),
                        Divider(color: Colors.grey, height: 1.h, thickness: 0.5),

                        //============================> Facebook Row <==========================
                        _buildInfoRow(
                          icon: Icons.facebook,
                          label: 'Facebook',
                          value: '',
                        ),
                        Divider(color: Colors.grey, height: 1.h, thickness: 0.5),
                        /*//===============================> Instagram Row <=========================
                        _buildInfoRow(
                          icon: Icons.facebook,
                          label: 'Instagram',
                          value: '',
                          trailingColor: Colors.grey[400],
                        ),
                         Divider(color: Colors.grey, height: 1.h, thickness: 0.5),*/
                        //=============================> Directions Row <=============================
                        _buildInfoRow(
                          icon: Icons.directions,
                          label: 'Directions',
                          value: '',
                          trailingColor: Colors.grey[400],
                        ),
                        Divider(color: Colors.grey, height: 1.h, thickness: 0.5),
                        //==============================> Call Row <===================================
                        _buildInfoRow(
                          icon: Icons.phone,
                          label: 'Call +880-1500000000',
                          value: '',
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: 16.h),
                  //==============================> Write A Review Button <===================================
                  CustomButton(onTap: (){Get.toNamed(AppRoutes.reviewsScreen);}, text: 'Write A Review'),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //==========================================> Build Info Row <===========================================
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    String? value,
    Color? trailingColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20.w),
          SizedBox(width: 16.w),
          Expanded(
            child: CustomText(
            text: label,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          ),
          if (value != null && value.isNotEmpty)
            CustomText(
             text: value,
                color: Colors.green,
                fontSize: 16.sp,
            ),
        ],
      ),
    );
  }
}
