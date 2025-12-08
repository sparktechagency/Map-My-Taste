import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../../helpers/prefs_helpers.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../base/bottom_menu..dart';
import '../../base/custom_button.dart';
import '../../base/custom_network_image.dart';
import '../../base/custom_text.dart';
import 'InnerWidget/custom_tab.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  RxList<String> selectedOptions = <String>[].obs;
  final Set<Marker> _markers = {};
  final LatLng _defaultPosition = const LatLng(40.730610, -73.935242);
  LatLng? _initialPosition;
  bool isSwitched = false;

  BitmapDescriptor? _restaurantIcon;

  final List<Map<String, dynamic>> tabs = [
    {'icon': Icons.sort, 'label': 'Sort'},
    {'icon': Icons.restaurant, 'label': 'Restaurants'},
    {'icon': Icons.hotel, 'label': 'Hotel'},
    {'icon': Icons.camera_alt, 'label': 'Things'},
    {'icon': Icons.museum, 'label': 'Museums'},
    {'icon': Icons.medical_information, 'label': 'Pharmacies'},
    {'icon': Icons.forest, 'label': 'Parks'},
    {'icon': Icons.local_hospital, 'label': 'Hospital'},
  ];

  final List<String> options = [
    'Distance  (Default)'.tr,
    'Most popular'.tr,
    'Highest rating'.tr,
    'A→Z'.tr,
    '\$→\$\$\$'.tr,
    '\$\$\$→\$'.tr,
  ];

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;

    if (_initialPosition != null) {
      _moveCameraWithOffset(_initialPosition!);
    } else {
      _moveCameraWithOffset(_defaultPosition);
    }
  }



  void _moveCameraWithOffset(LatLng position) {
    if (!_isMapReady || _mapController == null) return;

    double offset = 0.04;
    LatLng target = LatLng(position.latitude - offset, position.longitude);

    _mapController!.animateCamera(CameraUpdate.newLatLng(target));
  }




  void _onMapTapped(LatLng tappedPoint) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('selected_location'),
        position: tappedPoint,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      ));
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(tappedPoint));
  }


  // Function to convert a Flutter IconData into a BitmapDescriptor
  Future<BitmapDescriptor> getBitmapDescriptorFromIcon(
      IconData iconData, Color color, double size) async {

    // 1. Create a Picture Recorder and Canvas
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // 2. Define the icon painter and text style
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    final String iconText = String.fromCharCode(iconData.codePoint);

    // Use the default Icon font and style it with color and size
    textPainter.text = TextSpan(
        text: iconText,
        style: TextStyle(
            letterSpacing: 0.0,
            fontSize: size,
            fontFamily: iconData.fontFamily,
            color: color));

    // 3. Draw the icon onto the canvas
    textPainter.layout();
    textPainter.paint(canvas, Offset(0.0, 0.0));

    // 4. Convert the Canvas drawing (Picture) to an Image
    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(textPainter.width.toInt(), textPainter.height.toInt());

    // 5. Convert the Image to PNG ByteData
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    // 6. Return the BitmapDescriptor
    final Uint8List bytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }


  // ========================= GOOGLE PLACES NEARBY API =========================

  Future<void> _loadNearbyRestaurants(LatLng location) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${location.latitude},${location.longitude}"
        "&radius=1500"
        "&type=restaurant"
        "&key=AIzaSyBCfToXEXCt9L36Zri1FjoI9kMv_E076no"; // USE Manifest API key here

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      log("=====> ${data}");

      if (data["status"] == "OK") {
        List results = data["results"];

        // Clear existing markers, but you may want to keep the initial position marker
        // If you clear here, make sure to re-add the 'saved_location' marker if needed
        // For simplicity, we'll assume we're just adding to what's already there
        // _markers.clear(); // Removing this line for now to keep the saved location marker

        for (var r in results) {
          final lat = r["geometry"]["location"]["lat"];
          final lng = r["geometry"]["location"]["lng"];
          final name = r["name"];

          _markers.add(
            Marker(
              markerId: MarkerId(name),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(title: name),
              // 2. Use the custom icon here
              icon: _restaurantIcon ?? BitmapDescriptor.defaultMarker,
            ),
          );
        }

        setState(() {});
      } else {
        print("Places API Error: ${data["status"]}");
      }
    } catch (e) {
      print("Nearby API Error: $e");
    }
  }

  //=========================> Search location and update map with marker <=======================
  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final LatLng newPosition =
        LatLng(locations.first.latitude, locations.first.longitude);
     //  _mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
        setState(() {
          _markers.clear();
          _markers.add(Marker(
            markerId: const MarkerId('selected_location'),
            position: newPosition,
            infoWindow: InfoWindow(title: location),
          ));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found')));
    }
  }


  Future<void> _loadCustomIcon() async {
    try {
      _restaurantIcon = await getBitmapDescriptorFromIcon(
        Icons.restaurant, // Use the direct Flutter Icon
        Colors.pink,       // Choose your icon color
        50,             // Choose your icon size (e.g., 80.0)
      );
    } catch (e) {
      print("Error loading built-in icon as marker: $e");
      _restaurantIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCustomIcon().then((_) { // Load icon first
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSavedLocation();
      });
    });
  }

  void _loadSavedLocation() async {
    String? latStr = await PrefsHelper.getString('latitude');
    String? lonStr = await PrefsHelper.getString('longitude');

    LatLng newPosition;

    if (latStr.isNotEmpty && lonStr.isNotEmpty) {
      double lat = double.tryParse(latStr) ?? _defaultPosition.latitude;
      double lon = double.tryParse(lonStr) ?? _defaultPosition.longitude;
      newPosition = LatLng(lat, lon);
    } else {
      newPosition = _defaultPosition;
    }

    // Save to _initialPosition
    setState(() {
      _initialPosition = newPosition;

      // Add marker at saved location
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('saved_location'),
        position: _initialPosition!,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
    });

    // Animate camera if map is ready
    _moveCameraWithOffset(_initialPosition!);

    _loadNearbyRestaurants(_initialPosition!);
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      //=======================================> App Bar Section <===================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            Spacer(),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.notificationsScreen);
              },
              child: SvgPicture.asset(
                AppIcons.notification,
                width: 24.w,
                height: 24.h,
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.conversationScreen);
              },
              child: SvgPicture.asset(
                AppIcons.message,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child:
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition ?? _defaultPosition,
                zoom: 12.0,
              ),
              mapType: MapType.satellite,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              onTap: _onMapTapped,
              zoomGesturesEnabled: true,
            ),
          ),

          //============================> Search Bar at the top <==========================
          Positioned(
              top: 24.h,
              left: 10.w,
              right: 10.w,
              child: CustomTextField(
                controller: searchController,
                prefixIcon: SvgPicture.asset(AppIcons.search),
                labelText: 'Search'.tr,
              )
          ),
          //=============================> Restaurant List at the bottom <=======================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400.h,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 100.w,
                        child: Divider(thickness: 3.5),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                       // shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: tabs.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final tab = tabs[index];
                          return CustomTab(
                            icon: tab['icon'] as IconData,
                            label: tab['label'] as String,
                            onTap: index == 0
                                ? () {
                              _showBottomSheet();
                              print('First tab tapped!');
                            }
                                : null,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    //=================================> Restaurant list <========================
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.detailsScreen);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.fillColor,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Row(
                                  children: [
                                    CustomNetworkImage(
                                      imageUrl:
                                      'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                                      height: 64.h,
                                      width: 64.w,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomText(
                                                  text: 'Motin Miar Pizza Ghar',
                                                  fontSize: 20.sp,
                                                  textAlign: TextAlign.start,
                                                  maxLine: 2,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 5),
                                                  CustomText(
                                                    text: '4.9',
                                                    color: AppColors.greyColor,
                                                    fontSize: 16.sp,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              CustomText(
                                                text: AppStrings.restaurants.tr,
                                                fontSize: 16.sp,
                                                color: AppColors.greyColor,
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 5.w),
                                                  CustomText(
                                                    text: '0.5 km',
                                                    color: AppColors.greyColor,
                                                    fontSize: 16.sp,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 8.w),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondaryButtonColor,
                                                  borderRadius: BorderRadius.circular(6.r),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 4.h,
                                                  ),
                                                  child: CustomText(
                                                    text: AppStrings.open.tr,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //=======================================> Show Bottom Sheet <=============================
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12.h,
                  width: 48.w,
                  child: Divider(thickness: 4.9, color: Colors.grey),
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text: 'Sort By'.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 16.h),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Obx(
                          () => Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: CheckboxListTile(
                          key: Key('$index-${options[index]}'),
                          activeColor: AppColors.primaryColor,
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: AppColors.greyColor,
                            width: 1.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(text: options[index]),
                          ),
                          value:selectedOptions.contains(options[index].toLowerCase()),
                          onChanged: (bool? value) {
                            if (value == true) {
                             selectedOptions.add(options[index].toLowerCase());
                            } else {
                              selectedOptions.remove(options[index].toLowerCase());
                            }
                            print('==================> ${selectedOptions}');
                          },
                        ),
                      ),
                    );
                  },
                ),
                //==========================> Save Button <=============================
                CustomButton(
                  onTap: () {
                    Get.back();
                  },
                  text: AppStrings.save.tr,
                ),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

