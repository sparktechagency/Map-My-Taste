import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../service/api_client.dart';
import '../service/api_constants.dart';


class ReviewController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // ----------- Business ID -------------
  late final String businessId;

  // ----------- Review Inputs -------------
  RxInt rating = 0.obs;
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  List<TextEditingController> likedCtrls =
  List.generate(3, (_) => TextEditingController());
  List<TextEditingController> dislikedCtrls =
  List.generate(2, (_) => TextEditingController());

  // ----------- Photo Handling -------------
  Rx<XFile?> selectedPhoto = Rx<XFile?>(null);
  RxBool isUploadingPhoto = false.obs;

  @override
  void onInit() {
    super.onInit();
    // get businessId from Get.arguments
    businessId = Get.arguments ?? '';
  }

  // PICK IMAGE
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image != null) {
      selectedPhoto.value = image;
    }
  }

  // REMOVE IMAGE
  void removePhoto() {
    selectedPhoto.value = null;
  }

// ... (imports and class definition remain the same)

  Future<void> submitReview() async {
    if (!(formKey.currentState?.validate() ?? false) || rating.value == 0) {
      // Simple validation error

      // Removed: if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      // This line was causing the LateInitializationError crash when calling Get.back() later.

      Get.snackbar(
        "Error",
        "Please fill required fields and select a rating",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isUploadingPhoto(true);

    try {
      Map<String, String> body = {
        "business": businessId,
        "rating": rating.value.toString(),
        "title": titleCtrl.text.trim(),
        "description": descCtrl.text.trim(),
        "liked": likedCtrls.map((c) => c.text.trim()).where((e) => e.isNotEmpty).join(','),
        "disliked": dislikedCtrls.map((c) => c.text.trim()).where((e) => e.isNotEmpty).join(','),
      };

      List<MultipartBody> files = [];
      if (selectedPhoto.value != null) {
        files.add(MultipartBody("photo", File(selectedPhoto.value!.path)));
      }

      final response = await ApiClient.postMultipartData(
        ApiConstants.postUserReview,
        body,
        multipartBody: files,
      );

      log("====>response review ${response.body}");

      // ReviewController.submitReview - Inside if (response.statusCode == 201)
      if (response.statusCode == 201) {

        // The navigation is the only action on success.
        Get.back(result: {"success": true, "message": "Review submitted successfully!"});

      } else {
        // Keep cleanup for error SnackBar display
        if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

        Get.rawSnackbar(
          message: "Submission failed: ${response.statusText}",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
      }

    } catch (e) {
      // Keep cleanup for error SnackBar display
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

      Get.rawSnackbar(
        message: e.toString(),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploadingPhoto(false);
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    for (var c in likedCtrls) {
      c.dispose();
    }
    for (var c in dislikedCtrls) {
      c.dispose();
    }
    super.onClose();
  }
}
