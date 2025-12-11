import 'dart:developer';
import 'package:get/get.dart';

import '../models/category_list_model.dart';
import '../models/category_query_model.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';


class CategoryController extends GetxController {
  /// Loading for category list
  RxBool isCategoryLoading = false.obs;

  /// Loading for businesses inside selected category
  RxBool isBusinessLoading = false.obs;

  /// Category list
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  /// Business list based on selected category
  RxList<CategoryData> categoryBusinesses = <CategoryData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // ----------------------------
  // FETCH CATEGORY LIST
  // ----------------------------
  Future<void> fetchCategories() async {
    try {
      isCategoryLoading.value = true;

      final response = await ApiClient.getData(ApiConstants.getCategoryList);
      log("====> Category List API Response: $response");

      if (response.statusCode == 200) {
        final jsonData = response.body;

        final categoryResponse = CategoryListModel.fromJson(jsonData);
        categories.value = categoryResponse.data;

        log("====> Loaded ${categories.length} categories");
      } else {
        log("====> Category API Error: ${response.statusText}");
      }
    } catch (e) {
      log("====> Category Fetch Error: $e");
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // ----------------------------
  // FETCH BUSINESSES BY CATEGORY
  // ----------------------------
  Future<void> fetchBusinessesByCategory({
    required String category,
    required double latitude,
    required double longitude,
  }) async {
    try {
      isBusinessLoading.value = true;

      /// Build dynamic path
      final path = ApiConstants.queryCategory.replaceFirst(
        ":category",
        category,
      );

      /// API call with dynamic lat/lon
      final response = await ApiClient.getData(
        path,
        queryParams: {
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        },
      );

      log("======>query Response $response");

      if (response.statusCode == 200) {
        final jsonData = response.body;

        final parsed = CategoryQueryModel.fromJson(jsonData);
        categoryBusinesses.value = parsed.data;

        log("====> Loaded ${categoryBusinesses.length} businesses");
      } else {
        log("====> Category Query API Error: ${response.statusText}");
      }
    } catch (e) {
      log("====> CATEGORY QUERY ERROR: $e");
    } finally {
      isBusinessLoading.value = false;
    }
  }
}
