import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/views/base/custom_button.dart';
import 'package:map_my_taste/views/base/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/business_details_controller.dart';
import '../../../controllers/favourite_controller.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final controller = Get.put(BusinessDetailsController());
  bool _isFavorite = false;
  double? distance;
  final favouriteController = Get.put(FavouriteController());


  @override
  void initState() {
    super.initState();

    // Safely read arguments
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      // Extract 'distance' and convert to double
      final dist = args['distance'];
      if (dist != null) {
        if (dist is int) {
          distance = dist.toDouble();
        } else if (dist is double) {
          distance = dist;
        } else if (dist is String) {
          distance = double.tryParse(dist);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      final data = controller.details.value?.data;

      log("=====>data  $data");

      if (data == null) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              "No details found",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            // =================== Restaurant Image Header ===================
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          data.photos.isNotEmpty ? data.photos.first.photoUrl : "https://via.placeholder.com/300x200.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Back + Favorite
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

                        // ⭐ FAVORITE BUTTON ⭐
                        Obx(() {
                          return IconButton(
                            icon: favouriteController.isLoading.value
                                ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primaryColor,
                              ),
                            )
                                : Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: AppColors.primaryColor,
                              size: 28.w,
                            ),

                            onPressed: () {
                              // Call your toggle function with business ID
                              _toggleFavorite(data.id ?? '');
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // Category Icon
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
                        CustomText(
                          text: (data.category.capitalize ?? ''),
                          fontSize: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= Restaurant Info Section =================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,                    ),
                    // Name
                    CustomText(
                      text: data.name,
                      textAlign: TextAlign.start,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w700,
                      maxLine: 5,
                    ),
                    SizedBox(height: 8.h),

                    // Ratings + Open + Distance
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            if (index < data.rating.floor()) {
                              // Full star
                              return Icon(Icons.star, color: Colors.yellow[700], size: 20.w);
                            } else if (index < data.rating) {
                              // Half star
                              return Icon(Icons.star_half, color: Colors.yellow[700], size: 20.w);
                            } else {
                              // Empty star
                              return Icon(Icons.star_border, color: Colors.yellow[700], size: 20.w);
                            }
                          }),
                        ),

                        SizedBox(width: 8.w),
                        Text(
                          "(${data.totalReviews})",
                          style:
                          TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                        ),
                        SizedBox(width: 24.w),
                        Row(
                          children: [
                            Icon(Icons.access_time_outlined,
                                color: Colors.green, size: 20.w),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: (data.businessHours?.isOpen ?? false) ? "Open" : "Closed",
                              color: (data.businessHours?.isOpen ?? false) ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),

                          ],
                        ),
                        SizedBox(width: 16.w),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey[400], size: 20.w),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: distance != null ? "${distance!.toStringAsFixed(1)} km" : "N/A",
                    color: AppColors.greyColor,
                    fontSize: 16.sp,
                  ),
                ],


            ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Description
                    CustomText(
                      text: data.description,
                      fontSize: 16.sp,
                      textAlign: TextAlign.justify,
                      maxLine: 50,
                    ),
                    SizedBox(height: 24.h),

                    // Info Box
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.fillColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _buildInfoRow(
                              icon: Icons.language,
                              label: "Website",
                              value: data.contact!.website ?? ''),
                          Divider(color: Colors.grey),
                          _buildInfoRow(
                              icon: Icons.directions,
                              label: "${data.location!.address!.formattedAddress}",
                              trailingColor: Colors.grey[400],
                              maxLine: 5), // only Directions row uses more lines
                          Divider(color: Colors.grey),
                          _buildInfoRow(
                              icon: Icons.phone,
                              label: "Call ${data.contact!.phone}"),
                        ],
                      ),
                    ),

                    // ... (inside _DetailsScreenState.build)

                    SizedBox(height: 16.h),

                    CustomButton(
                      // ------------------------------------------------------------------
                      // In _DetailsScreenState.build, inside CustomButton onTap:

                      onTap: () async {
                        var result = await Get.toNamed(
                            AppRoutes.reviewsScreen,
                            arguments: data.id
                        );

                        // Check the result returned from ReviewController
                        if (result != null && result is Map && result["success"] == true) {

                          // ==========================================================
                          // >> FIX: Use PostFrameCallback to ensure Overlay is ready <<
                          // ==========================================================
                          if (mounted) { // Add mounted check for extra safety, though PostFrameCallback implies it should be
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Get.rawSnackbar(
                                message: result["message"] as String? ?? "Review submitted successfully!",
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            });
                          }
                        }
                      },

                      text: "Write A Review",
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ================= Build Info Row =================
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    String? value, // this is the actual URL
    Color? trailingColor,
    int maxLine = 1, // default 1 line
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20.w),
          SizedBox(width: 16.w),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (value != null && value.isNotEmpty) {
                  final uri = Uri.parse(value);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    print("Could not launch $value");
                  }
                }
              },
              child: CustomText(
                text: label, // show "Website" or actual text
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
                maxLine: maxLine,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Inside _DetailsScreenState in details_screen.dart

  void _toggleFavorite(String businessId) async {
    // Prevent multiple rapid taps
    if (favouriteController.isLoading.value) return;

    // 1. Await the API call to toggle favorite status
    await favouriteController.addToFavourite(businessId);

    // ⭐️ CRITICAL FIX: Ensure the widget is still in the tree (mounted)
    // before performing any UI updates (setState, Get.rawSnackbar).
    if (!mounted) {
      // If the widget is no longer in the widget tree, stop execution
      // to prevent calling UI methods on a stale context.
      return;
    }

    // 2. Process API Response
    if (favouriteController.addFavouriteResponse.value.success == true) {
      // Success: update UI and show snackbar

      // 💡 Note: If _isFavorite is an RxBool in the controller,
      // you might not need setState here, but if it's local state, keep it.
      setState(() {
        _isFavorite = true;
      });

      Get.rawSnackbar(
        message: favouriteController.addFavouriteResponse.value.message ?? "Added to favorites",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Failure: show error message

      Get.rawSnackbar(
        message: favouriteController.errorMessage.value.isNotEmpty
            ? favouriteController.errorMessage.value
            : "Failed to add favorite",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


}
