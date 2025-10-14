/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchCTRL = TextEditingController();
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  static const LatLng _initialPosition = LatLng(40.730610, -73.935242);

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
      body: Stack(
        children: [
          //=========================> Google Map <==========================
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers, // Display markers
            onTap: _onMapTapped, // Capture tap event
          ),

          //========================> Search Bar with Filter Icon <=======================
          Positioned(
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 2.w, color: AppColors.primaryColor)),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.r),
                          topLeft: Radius.circular(16.r))),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Select your location'.tr,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          bottom: 14.h,
                        ),
                        CustomTextField(
                          filColor: Colors.white,
                          controller: _searchCTRL,
                          hintText: 'Search here..',
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: InkWell(
                                onTap: () {},
                                child: SvgPicture.asset(AppIcons.eyeIcon)),
                          ),
                          suffixIcons: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: InkWell(
                                onTap: () {
                                  _searchLocation(_searchCTRL.text);
                                },
                                child: SvgPicture.asset(AppIcons.eyeIcon)),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        CustomButton(
                          onTap: () {},
                          text: 'Confirm location'.tr,
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
