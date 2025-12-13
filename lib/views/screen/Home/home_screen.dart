import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_images.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/bottom_menu..dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../../controllers/search_controller.dart';
import '../../../helpers/prefs_helpers.dart';
import '../../base/custom_page_loading.dart';
import '../../base/custom_text.dart';
import 'InnerWidget/filter_bottom_sheet.dart';
import 'InnerWidget/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchCTRL = TextEditingController();
  final BusinessSearchController controller = Get.put(BusinessSearchController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreBusinesses();
      }
    });

    // Synchronous callback, call async function inside
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndHandleLocation(); // no await here
    });

    searchCTRL.addListener(() {
      final query = searchCTRL.text.trim();
      controller.search(query);
    });
  }

// Async helper
  Future<void> _initializeAndHandleLocation() async {
    await _initializeCurrentPosition();
    await _handleFirstTimeLocation();
  }

// =================== Async initialization from Prefs ===================
  Future<void> _initializeCurrentPosition() async {
    String? lat = await PrefsHelper.getString('latitude');
    String? lon = await PrefsHelper.getString('longitude');

    if (lat.isNotEmpty && lon.isNotEmpty) {
      final double? latitude = double.tryParse(lat);
      final double? longitude = double.tryParse(lon);

      if (latitude != null && longitude != null) {
        controller.currentPosition.value = LatLng(latitude, longitude);
        log("Controller currentPosition initialized from Prefs: $latitude, $longitude");
      }
    }
  }



  /// Handle location permission and service only if latitude/longitude not saved
  Future<void> _handleFirstTimeLocation() async {
    // Check if location already saved
    String? lat = await PrefsHelper.getString('latitude');
    String? lon = await PrefsHelper.getString('longitude');
    if (lat.isNotEmpty && lon.isNotEmpty) {
      log("Location already saved: $lat, $lon.");
      controller.fetchNearbyBusinesses(
        latitude: double.tryParse(lat),
        longitude: double.tryParse(lon),
      );
      return;
    }


    bool granted = false;

    // Keep asking until permission granted and location service enabled
    while (!granted) {
      // Step 1: Request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        await _showMandatoryPermissionDialog(
          "Location permission denied",
          "This app requires location access to work properly. Please grant permission.",
        );
        continue;
      }

      if (permission == LocationPermission.deniedForever) {
        await _showMandatoryPermissionDialog(
          "Location permission permanently denied",
          "Please enable location permission from settings to continue.",
          openSettings: true,
        );
        continue;
      }

      // Step 2: Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool opened = await _showMandatoryPermissionDialog(
          "Location services disabled",
          "Please enable location services to continue.",
          openSettings: true,
        );
        if (!opened) continue;
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) continue;
      }

      // Step 3: Get location
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        await PrefsHelper.setString('latitude', position.latitude.toString());
        await PrefsHelper.setString('longitude', position.longitude.toString());
        await PrefsHelper.setBool('isFirstTimeLocation', false);
        log("Saved Location: ${position.latitude}, ${position.longitude}");

        // ✅ Call fetchNearbyBusinesses
        controller.fetchNearbyBusinesses(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        granted = true; // exit the loop
      } catch (e) {
        await _showMandatoryPermissionDialog(
          "Failed to get location",
          "Something went wrong while fetching your location. Please try again.",
        );
      }
    }
  }

  /// Shows a modal dialog that cannot be dismissed until user takes action
  Future<bool> _showMandatoryPermissionDialog(String title, String message,
      {bool openSettings = false}) async {
    bool userAction = false;
    await showDialog(
      context: context,
      barrierDismissible: false, // force user to choose
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // prevent back button dismiss
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            if (openSettings)
              TextButton(
                onPressed: () async {
                  userAction = true;
                  Navigator.pop(context);
                  await Geolocator.openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
            TextButton(
              onPressed: () {
                userAction = true;
                Navigator.pop(context);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
    return userAction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(0),
      //=======================================> App Bar Section <===================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            /*Spacer(),
            InkWell(
              onTap: () {Get.toNamed(AppRoutes.notificationsScreen);},
              child: SvgPicture.asset(
                AppIcons.notification,
                width: 24.w,
                height: 24.h,
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () {Get.toNamed(AppRoutes.conversationScreen);},
              child: SvgPicture.asset(
                AppIcons.message,
                width: 24.w,
                height: 24.h,
              ),
            ),*/
          ],
        ),
      ),
      //=======================================> Body Section <===================================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            //=======================================> Search And Filter Row <===================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 328.w,
                  child: CustomTextField(
                    controller: searchCTRL,
                    hintText: AppStrings.searchForRestaurants.tr,
                    prefixIcon: SvgPicture.asset(AppIcons.search),
                  ),
                ),


                InkWell(
                  onTap: () async {

                    final result = await showModalBottomSheet<Map<String, dynamic>>(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return FilterBottomSheet();
                      },
                    );


                    if (!mounted) {
                      log('HomeScreen disposed during filter flow. Exiting onTap.');
                      return;
                    }

                    if (result != null) {

                      String? latString = await PrefsHelper.getString('latitude');
                      String? lonString = await PrefsHelper.getString('longitude');

                      final double? lat = double.tryParse(latString ?? '');
                      final double? lon = double.tryParse(lonString ?? '');

                      // ⭐️ DEBUG 1: Check the raw result and location ⭐️
                      log('Filter sheet returned result: $result');
                      log('Current Position from Prefs: lat=$lat, lon=$lon');

                      // Check for missing location data
                      if (lat == null || lon == null) {
                        log('Location data missing or invalid in storage. Cannot filter by nearby location. Exiting.');
                        return;
                      }

                      // ⭐️ EXTREME FIX: Dispatch the API call outside of the current frame ⭐️
                      Future.microtask(() async {
                        if (!mounted) {
                          log('Microtask skipped: HomeScreen disposed while pending.');
                          return;
                        }

                        // Extract values with explicit type casting and null handling
                        final String? category = result['category'] as String?;
                        final double? minRating = result['minRating'] as double?;
                        final bool? openNow = result['openNow'] as bool?;
                        final bool? isVerified = result['isVerified'] as bool?;

                        // ⭐️ DEBUG 2: Check final values sent to API ⭐️
                        log('--- Dispatching fetchNearbyBusinesses with Filters ---');
                        log('Category: $category, MinRating: $minRating, OpenNow: $openNow, Verified: $isVerified');

                        // 3. Call the API asynchronously
                        await controller.fetchNearbyBusinesses(
                          latitude: lat, // Now reliably parsed from storage
                          longitude: lon, // Now reliably parsed from storage
                          category: category,
                          openNow: openNow,
                          isVerified: isVerified,
                          minRating: minRating,
                        );
                      });

                      // 4. Immediately return from the onTap function.
                      return;
                    } else {
                      log('Filter sheet dismissed without applying filters (result was null).');
                    }
                  },
                  child: SvgPicture.asset(AppIcons.filter),
                )



              ],
            ),
            //=======================================> Post Card Section <===================================
            // Post Cards
            // 🛑 FIX: Wrap Obx in Expanded to give the ListView a constrained height
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.businesses.isEmpty) {
                  return Center(child: CustomPageLoading());
                }

                if (controller.businesses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: CustomText(text: "No businesses found"),
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  // NOTE: Adjusted padding for the list items
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  // Adjusted itemCount: items + loader (if hasMore)
                  itemCount: controller.businesses.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Removed the redundant index == 0 header logic.

                    if (index < controller.businesses.length) {
                      final business = controller.businesses[index];
                      return PostCard(business: business);
                    }

                    // Bottom loader for pagination
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                );
              }),
            ),


          ],
        ),
      ),
    );
  }
}
