import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
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
  TextEditingController searchController = TextEditingController();
  late GoogleMapController _mapController;
  RxList<String> selectedOptions = <String>[].obs;
  final Set<Marker> _markers = {};
  static const LatLng _initialPosition = LatLng(40.730610, -73.935242);
  bool isSwitched = false;

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
    _mapController.animateCamera(CameraUpdate.newLatLng(tappedPoint));
  }

  //=========================> Search location and update map with marker <=======================
  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final LatLng newPosition =
        LatLng(locations.first.latitude, locations.first.longitude);
        _mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
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
          SnackBar(content: CustomText(text: 'Location not found')));
    }
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
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              onTap: _onMapTapped,
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

