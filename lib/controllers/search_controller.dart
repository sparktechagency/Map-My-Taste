import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/search_model.dart';

import '../service/api_client.dart';

class BusinessSearchController extends GetxController {
  // =================== Reactive Variables ===================
  RxList<Business> businesses = <Business>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  RxString searchKeyword = ''.obs;

  // =================== API Call ===================
  Future<void> fetchNearbyBusinesses({
    required double? latitude,
    required double? longitude,
    String? keyword,
    int? page,
    int? limit,
    double? radius,
    String? cuisineType,
    String? priceRange,
    bool? hasParking,
    bool? hasDelivery,
    bool? openNow,
    String? category,
    bool? isVerified,
    String? sort,


  }) async {
    if (latitude == null || longitude == null) {
      errorMessage.value = 'Latitude and Longitude are required';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';


    try {
      Map<String, String> queryParams = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };

      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (radius != null) queryParams['radius'] = radius.toString();
      if (keyword != null && keyword.isNotEmpty) queryParams['search'] = keyword;
      if (cuisineType != null) queryParams['cuisineType'] = cuisineType;
      if (priceRange != null) queryParams['priceRange'] = priceRange;
      if (hasParking != null) queryParams['hasParking'] = hasParking.toString();
      if (hasDelivery != null) queryParams['hasDelivery'] = hasDelivery.toString();
      if (openNow != null) queryParams['openNow'] = openNow.toString();
      if (category != null) queryParams['category'] = category;
      if (isVerified != null) queryParams['isVerified'] = isVerified.toString();

      // ⭐ Add Sorting Parameter
      if (sort != null) queryParams['sort'] = sort;
      // =================== ApiClient Call ===================
      final response = await ApiClient.getData(
        '/businesses/search/nearby',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonData = response.body is String ? jsonDecode(response.body) : response.body;
        final searchResponse = SearchModel.fromJson(jsonData);

        if (searchResponse.success) {
          businesses.value = searchResponse.data;
        } else {
          errorMessage.value = searchResponse.message;
        }
      } else {
        errorMessage.value = 'Error ${response.statusCode}: ${response.statusText}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // =================== Search Action ===================
  void search(String keyword) {
    searchKeyword.value = keyword;
    fetchNearbyBusinesses(
      latitude: currentPosition.value?.latitude,
      longitude: currentPosition.value?.longitude,
      keyword: keyword,
    );
  }

  // =================== Set Current Position ===================
  void setCurrentPosition(LatLng position) {
    currentPosition.value = position;
    // Auto-fetch nearby businesses when location is set
    fetchNearbyBusinesses(latitude: position.latitude, longitude: position.longitude);
  }
}
