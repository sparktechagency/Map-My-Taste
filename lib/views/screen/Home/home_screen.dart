import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/helpers/route.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_images.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/bottom_menu..dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../../helpers/prefs_helpers.dart';
import 'InnerWidget/filter_bottom_sheet.dart';
import 'InnerWidget/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchCTRL = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ask for permission only if location not saved
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleFirstTimeLocation();
    });
  }

  /// Handle location permission and service only if latitude/longitude not saved
  void _handleFirstTimeLocation() async {
    // Check if location already saved
    String? lat = await PrefsHelper.getString('latitude');
    String? lon = await PrefsHelper.getString('longitude');
    if (lat.isNotEmpty && lon.isNotEmpty) {
      print("Location already saved: $lat, $lon. Skipping permission request.");
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
        print("Saved Location: ${position.latitude}, ${position.longitude}");

        // Step 4: Set first-time flag
        await PrefsHelper.setBool('isFirstTimeLocation', false);

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
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            Spacer(),
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
            ),
          ],
        ),
      ),
      //=======================================> Body Section <===================================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
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
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return FilterBottomSheet();
                        },
                      );

                    },
                    child: SvgPicture.asset(AppIcons.filter),
                  ),
                ],
              ),
              //=======================================> Post Card Section <===================================
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return PostCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
