import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/search_model.dart';

import '../service/api_client.dart';
import 'category_list_controller.dart';

class BusinessSearchController extends GetxController {
  // =================== Reactive Variables ===================
  RxList<Business> businesses = <Business>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPaginating = false.obs;
  RxString errorMessage = ''.obs;

  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  RxString searchKeyword = ''.obs;
  RxList<Business> allBusinesses = <Business>[].obs;

  RxnString selectedCategory = RxnString();
  RxnDouble selectedMinRating = RxnDouble();
  RxnBool selectedOpenNow = RxnBool();
  RxnBool selectedIsVerified = RxnBool();

  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;
  final int perPage = 10;


  @override
  void onInit() {
    super.onInit();
    ever(searchKeyword, (String keyword) {
      _filterLocalBusinesses(keyword);
    });
  }

  // =================== Core Fetching Method ===================
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
    bool loadMore = false,
  }) async {
    if (latitude == null || longitude == null) {
      errorMessage.value = 'Latitude and Longitude are required';
      log('PAGINATION FAIL: Latitude or Longitude is null. Exiting fetchNearbyBusinesses.');
      return;
    }

    if (!loadMore) {
      isLoading.value = true;
      currentPage.value = 1;

      selectedCategory.value = category;
      selectedMinRating.value = minRating;
      selectedOpenNow.value = openNow;
      selectedIsVerified.value = isVerified;
    }


    errorMessage.value = '';

    try {
      Map<String, String> queryParams = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'page': (page ?? currentPage.value).toString(),
        'limit': (limit ?? perPage).toString(),
      };

      final activeSearch = keyword ?? searchKeyword.value;
      final activeCategory = category ?? selectedCategory.value;
      final activeMinRating = minRating ?? selectedMinRating.value;
      final activeOpenNow = openNow ?? selectedOpenNow.value;
      final activeIsVerified = isVerified ?? selectedIsVerified.value;

      if (activeSearch.isNotEmpty) queryParams['search'] = activeSearch;
      if (activeCategory != null) queryParams['category'] = activeCategory;
      if (activeMinRating != null) queryParams['minRating'] = activeMinRating.toString();
      if (activeOpenNow != null) queryParams['openNow'] = activeOpenNow.toString();
      if (activeIsVerified != null) queryParams['isVerified'] = activeIsVerified.toString();

      if (keyword != null && keyword.isNotEmpty) queryParams['search'] = keyword;
      if (radius != null) queryParams['radius'] = radius.toString();
      if (minRating != null) queryParams['minRating'] = minRating.toString();
      if (cuisineType != null) queryParams['cuisineType'] = cuisineType;
      if (priceRange != null) queryParams['priceRange'] = priceRange;
      if (hasParking != null) queryParams['hasParking'] = hasParking.toString();
      if (hasDelivery != null) queryParams['hasDelivery'] = hasDelivery.toString();
      if (openNow != null) queryParams['openNow'] = openNow.toString();
      if (category != null) queryParams['category'] = category;
      if (isVerified != null) queryParams['isVerified'] = isVerified.toString();
      if (sort != null) queryParams['sort'] = sort;

      // LOGGING API PARAMETERS BEFORE CALL (This log was missing in your previous output)
      log('API Call: Page: ${queryParams['page']}, LoadMore: $loadMore, Keyword: ${queryParams['search'] ?? 'none'}');
      log('Guard Status: hasMore: ${hasMore.value}, isLoading: ${isLoading.value}, isPaginating: ${isPaginating.value}');

      final response = await ApiClient.getData(
        '/businesses/search/nearby',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonData = response.body is String ? jsonDecode(response.body) : response.body;
        final searchResponse = SearchModel.fromJson(jsonData);

        if (searchResponse.success) {
          final newBusinesses = searchResponse.data;

          if (loadMore) {
            allBusinesses.addAll(newBusinesses);
          } else {
            allBusinesses.value = newBusinesses;
          }

          hasMore.value = newBusinesses.length == perPage;
          currentPage.value = page ?? 1;

          log('API Success: Fetched ${newBusinesses.length} items. New currentPage: ${currentPage.value}, hasMore: ${hasMore.value}');

          _filterLocalBusinesses(searchKeyword.value);

        } else {
          errorMessage.value = searchResponse.message;
        }
      } else {
        log('API Fail: Received status code ${response.statusCode} for page ${queryParams['page']}');
        errorMessage.value = 'Error ${response.statusCode}: ${response.statusText}';
      }
    } catch (e) {
      log('API Exception for page ${page ?? currentPage.value}: $e');
      errorMessage.value = 'Exception: $e';
    } finally {
      if (!loadMore) {
        isLoading.value = false;
      }

    }
  }


  // =================== Pagination Helper Method (FIXED) ===================
  void loadMoreBusinesses() {
    log('Attempting Load More: hasMore: ${hasMore.value}, isPaginating: ${isPaginating.value}');

    // 🛑 NEW CHECK: Guard against null location before proceeding
    final LatLng? pos = currentPosition.value;
    if (pos == null) {
      log('PAGINATION BLOCKED: Current position is null, cannot call API.');
      return;
    }

    // Check if more data exists AND if a pagination load is not already in progress
    if (hasMore.value && !isPaginating.value) {

      // 🛑 FIX: Set the guard flag immediately before the async call
      isPaginating.value = true;
      log('DEBUG: isPaginating set to true by loadMoreBusinesses (Guard Activated)');

      log('--- Paginating: API Call Triggered for Page ${currentPage.value + 1} ---');
      currentPage.value++;

      fetchNearbyBusinesses(
        latitude: pos.latitude,
        longitude: pos.longitude,
        keyword: searchKeyword.value,
        page: currentPage.value,
        loadMore: true,
      ).then((_) {
        // 🛑 CRITICAL: Clear the flag ONLY after the fetch is fully complete
        isPaginating.value = false;
        log('DEBUG: isPaginating set to false after API completion. Ready for next page.');
      });
    } else {
      log('--- Paginating Blocked (Guard failed) ---');
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

    if (!localOnly) {
      fetchNearbyBusinesses(
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        keyword: keyword,
        loadMore: false,
      );
    }
  }


  // =================== Set Current Position ===================
  void setCurrentPosition(LatLng position) {
    currentPosition.value = position;
    fetchNearbyBusinesses(latitude: position.latitude, longitude: position.longitude);
  }

  // =================== Filter by Category (Local Only Example) ===================
  void applyCategoryFilter() {
    if (Get.isRegistered<CategoryController>() == false) return;

    final categoryController = Get.find<CategoryController>();
    if (categoryController.categoryBusinesses.isEmpty) return;

    final filteredIds = categoryController.categoryBusinesses.map((e) => e.id).toList();

    // Filtering locally only on the currently loaded master list
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
      if (a.distance == null) return 1;
      if (b.distance == null) return -1;
      return a.distance!.compareTo(b.distance!);
    });
  }

}