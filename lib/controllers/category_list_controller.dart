import 'dart:developer';
import 'package:get/get.dart';

import '../models/category_list_model.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';


class CategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.getData(ApiConstants.getCategoryList);

      log("====> response $response");

      if (response.statusCode == 200) {
        // Already decoded Map
        final jsonData = response.body;

        try {
          final categoryResponse = CategoryListModel.fromJson(jsonData);
          categories.value = categoryResponse.data;
          log("=====> Parsing Successful: ${categories.length} categories loaded");
        } catch (e) {
          log("=====> CRITICAL PARSING ERROR: $e");
          throw Exception(e);
        }
      } else {
        log("=====> API Error: ${response.statusText}");
      }
    } catch (e) {
      log("=====> FINAL CATCH BLOCK: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
