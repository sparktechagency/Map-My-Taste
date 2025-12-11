import 'dart:developer';

import 'package:get/get.dart';
import 'package:map_my_taste/service/api_constants.dart';
import '../models/business_details_model.dart';
import '../service/api_client.dart';


class BusinessDetailsController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<BusinessDetailsModel> details = Rxn<BusinessDetailsModel>();
  late String businessId;
  double? distance; // optional distance from arguments

  @override
  void onInit() {
    super.onInit();
    // Parse arguments as a Map
    final args = Get.arguments as Map<String, dynamic>;
    businessId = args['id'] ?? '';
    distance = args['distance'] != null ? (args['distance'] as num).toDouble() : null;
  }

  @override
  void onReady() {
    super.onReady();
    getBusinessDetails(businessId);
  }

  // --- TEMPORARY FIX FOR DEBUGGING ---
  Future<void> getBusinessDetails(String id) async {
    try {
      isLoading.value = true;
      final response =
      await ApiClient.getData("${ApiConstants.getBusinessDetails}$id");

      log("====> response $response");

      if (response.statusCode == 200) {
        // Already decoded JSON (Map)
        final jsonData = response.body;

        try {
          details.value = BusinessDetailsModel.fromJson(jsonData);
          log("=====> Parsing Successful: ${details.value?.data!.name}");
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
