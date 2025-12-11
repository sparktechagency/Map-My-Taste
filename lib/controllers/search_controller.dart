import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/search_model.dart';

import '../service/api_client.dart';
import 'category_list_controller.dart';

class BusinessSearchController extends GetxController {
  // =================== Reactive Variables ===================
  RxList<Business> businesses = <Business>[].obs; // displayed list
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  RxString searchKeyword = ''.obs;
  RxList<Business> allBusinesses = <Business>[].obs; // master list

  @override
  void onInit() {
    super.onInit();

    // Listen to searchKeyword changes for local filtering
    ever(searchKeyword, (String keyword) {
      _filterLocalBusinesses(keyword);
    });
  }

  // =================== API Call ===================
  Future<void> fetchNearbyBusinesses({
    required double? latitude,
    required double? longitude,
    String? keyword,
    int? page,
    int? limit,
    double? radius,
    double? minRating,
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

      log('======> API Request: /businesses/search/nearby');
      log('Query Params: $queryParams');

      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (radius != null) queryParams['radius'] = radius.toString();
      if (minRating != null) queryParams['minRating'] = minRating.toString();
      if (keyword != null && keyword.isNotEmpty) queryParams['search'] = keyword;
      if (cuisineType != null) queryParams['cuisineType'] = cuisineType;
      if (priceRange != null) queryParams['priceRange'] = priceRange;
      if (hasParking != null) queryParams['hasParking'] = hasParking.toString();
      if (hasDelivery != null) queryParams['hasDelivery'] = hasDelivery.toString();
      if (openNow != null) queryParams['openNow'] = openNow.toString();
      if (category != null) queryParams['category'] = category;
      if (isVerified != null) queryParams['isVerified'] = isVerified.toString();
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
          allBusinesses.value = searchResponse.data; // master copy
          print('Filtered Businesses Count: ${allBusinesses.length}');
          _filterLocalBusinesses(searchKeyword.value); // filter if search already typed
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

  // =================== Local Search Filter ===================
  void _filterLocalBusinesses(String keyword) {
    if (keyword.isEmpty) {
      businesses.value = List.from(allBusinesses);
    } else {
      businesses.value = allBusinesses
          .where((b) => b.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
  }

  void search(String keyword, {bool localOnly = true}) {
    searchKeyword.value = keyword;

    if (localOnly) {
      // Local filter
      if (keyword.isEmpty) {
        businesses.value = List.from(allBusinesses);
      } else {
        businesses.value = allBusinesses
            .where((b) => b.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    } else {
      // Optional: call API if needed
      fetchNearbyBusinesses(
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        keyword: keyword,
      );
    }
  }


  // =================== Set Current Position ===================
  void setCurrentPosition(LatLng position) {
    currentPosition.value = position;
    // Auto-fetch nearby businesses when location is set
    fetchNearbyBusinesses(latitude: position.latitude, longitude: position.longitude);
  }

  // =================== Filter by Category ===================
  void applyCategoryFilter() {
    if (Get.isRegistered<CategoryController>() == false) return;

    final categoryController = Get.find<CategoryController>();
    if (categoryController.categoryBusinesses.isEmpty) return;

    final filteredIds = categoryController.categoryBusinesses.map((e) => e.id).toList();

    final filteredList = allBusinesses.where((b) => filteredIds.contains(b.id)).toList();
    businesses.value = filteredList;
  }

  // =================== Optional Sorting ===================
  void sortByName() {
    businesses.sort((a, b) => a.name.compareTo(b.name));
  }

  void sortByDistance() {
    businesses.sort((a, b) {
      if (a.distance == null && b.distance == null) return 0;
      if (a.distance == null) return 1; // a goes after b
      if (b.distance == null) return -1; // b goes after a
      return a.distance!.compareTo(b.distance!);
    });
  }

}
