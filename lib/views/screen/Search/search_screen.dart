
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../../controllers/category_list_controller.dart';
import '../../../controllers/search_controller.dart';
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BusinessSearchController searchController = Get.put(BusinessSearchController());
  TextEditingController searchTextController = TextEditingController();
  final CategoryController categoryController = Get.put(CategoryController());
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  RxList<String> selectedOptions = <String>[].obs;
  final Set<Marker> _markers = {};
  final LatLng _defaultPosition = const LatLng(40.730610, -73.935242);
  LatLng? _initialPosition;
  bool isSwitched = false;
  BitmapDescriptor? _restaurantIcon;

  final List<Map<String, dynamic>> staticTabs = [
    {'icon': Icons.sort, 'label': 'Sort'},
  ];

  RxList<Map<String, dynamic>> tabs = <Map<String, dynamic>>[].obs;


  final List<String> options = [
    'Distance  (Default)'.tr,
    'Most popular'.tr,
    'Highest rating'.tr,
    'A→Z'.tr,
    '\$→\$\$\$'.tr,
    '\$\$\$→\$'.tr,
  ];

  @override
  void initState() {
    super.initState();

    _loadCustomIcon().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSavedLocation();
      });
    });

    searchTextController.addListener(() {
      final keyword = searchTextController.text.trim();
      if (keyword.isNotEmpty) {
        searchController.search(keyword);
      }
    });


    ever(categoryController.categories, (_) {
      final dynamicTabs = categoryController.categories.map((c) {
        return {
          'icon': c.icon, // String emoji from API, can be null
          'label': c.displayName
        };
      }).toList();

      tabs.value = [...staticTabs, ...dynamicTabs];
    });
  }

  // ==================== Map & Marker Functions ====================
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

  Future<BitmapDescriptor> getBitmapDescriptorFromIcon(
      IconData iconData, Color color, double size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    final String iconText = String.fromCharCode(iconData.codePoint);

    textPainter.text = TextSpan(
      text: iconText,
      style: TextStyle(
          fontSize: size, fontFamily: iconData.fontFamily, color: color),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final ui.Image image =
    await pictureRecorder.endRecording().toImage(textPainter.width.toInt(), textPainter.height.toInt());

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _loadCustomIcon() async {
    try {
      _restaurantIcon = await getBitmapDescriptorFromIcon(Icons.restaurant, Colors.pink, 50);
    } catch (e) {
      print("Error loading icon: $e");
      _restaurantIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
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

    setState(() {
      _initialPosition = newPosition;
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('saved_location'),
        position: _initialPosition!,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
    });

    _moveCameraWithOffset(_initialPosition!);

    // Set current position in controller & fetch nearby businesses
    searchController.setCurrentPosition(_initialPosition!);

    _loadNearbyRestaurants(_initialPosition!);
  }

  // ==================== UI Builder ====================
  Widget _buildBusinessList() {
    return Obx(() {
      if (searchController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (searchController.errorMessage.value.isNotEmpty) {
        return Center(child: Text(searchController.errorMessage.value));
      } else if (searchController.businesses.isEmpty) {
        return Center(child: Text('No restaurants found'));
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchController.businesses.length,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemBuilder: (context, index) {
            final business = searchController.businesses[index];

            final String imageUrl = business.photos != null && business.photos!.isNotEmpty
                ? business.photos!.first.photoUrl
                : 'https://via.placeholder.com/64'; // fallback image

            final double rating = business.rating ?? 0.0;
            final double distance = business.distance ?? 0.0;
            final bool isOpen = business.businessHours?.isOpen ?? false;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.detailsScreen,   arguments: {
                    'id': business.id,
                    'distance': business.distance,       // new value
                  },);
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
                          imageUrl: imageUrl,
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
                                      text: business.name,
                                      fontSize: 20.sp,
                                      textAlign: TextAlign.start,
                                      maxLine: 2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow, size: 20),
                                      SizedBox(width: 5),
                                      CustomText(
                                        text: rating.toStringAsFixed(1),
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
                                    text: business.category,
                                    fontSize: 16.sp,
                                    color: AppColors.greyColor,
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                                      SizedBox(width: 5.w),
                                      CustomText(
                                        text: '${distance.toStringAsFixed(1)} km',
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
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                      child: CustomText(
                                        text: isOpen ? AppStrings.open.tr : AppStrings.close.tr,
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
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            Spacer(),
            InkWell(
              onTap: () => Get.toNamed(AppRoutes.notificationsScreen),
              child: SvgPicture.asset(AppIcons.notification, width: 24.w, height: 24.h),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () => Get.toNamed(AppRoutes.conversationScreen),
              child: SvgPicture.asset(AppIcons.message, width: 24.w, height: 24.h),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
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
          Positioned(
            top: 24.h,
            left: 10.w,
            right: 10.w,
            child: CustomTextField(
              controller: searchTextController,
              prefixIcon: SvgPicture.asset(AppIcons.search),
              labelText: 'Search'.tr,
            ),
          ),
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
                    Center(child: SizedBox(width: 100.w, child: Divider(thickness: 3.5))),
                    SizedBox(height: 24.h),
                    SizedBox(
                      height: 40.h,
                      child: Obx(() {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: tabs.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final tab = tabs[index];
                            return CustomTab(
                              label: tab['label'] as String,
                              onTap: index == 0 ? _showBottomSheet : null,
                            );
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 24.h),
                    _buildBusinessList(), // Dynamic restaurant list
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //======================== Bottom Sheet ========================
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
              children: [
                SizedBox(height: 12.h, width: 48.w, child: Divider(thickness: 4.9, color: Colors.grey)),
                SizedBox(height: 16.h),
                CustomText(text: 'Sort By'.tr, fontSize: 18.sp, fontWeight: FontWeight.w700),
                SizedBox(height: 16.h),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.fillColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: CheckboxListTile(
                          key: Key('$index-${options[index]}'),
                          activeColor: AppColors.primaryColor,
                          checkColor: Colors.white,
                          side: BorderSide(color: AppColors.greyColor, width: 1.w),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                          title: Align(alignment: Alignment.centerLeft, child: CustomText(text: options[index])),
                          value: selectedOptions.contains(options[index].toLowerCase()),
                          onChanged: (bool? value) {
                            if (value == true) {
                              selectedOptions.add(options[index].toLowerCase());
                            } else {
                              selectedOptions.remove(options[index].toLowerCase());
                            }
                          },
                        ),
                      );
                    });
                  },
                ),
                CustomButton(onTap: () => Get.back(), text: AppStrings.save.tr),
                SizedBox(height: 48.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

