import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../service/api_client.dart';
import '../service/api_constants.dart';

class ReviewController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // ----------- Business ID -------------
  late final String businessId;
  late final String businessName;


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

    final args = Get.arguments ?? {};
    businessId = args["id"] ?? "";
    businessName = args["name"] ?? "";
  }


  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.black),
              title: const Text(
                "Take Photo",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.black),
              title: const Text(
                "Choose from Gallery",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }



  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
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


  Future<void> submitReview() async {
    // ⭐ Validation

    if (rating.value < 1) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select at least 1 star.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields correctly.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // ⭐ Description length validation
    if (descCtrl.text.trim().length < 10) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "Description must be at least 10 characters.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    isUploadingPhoto(true);

    try {
      // Prepare body
      Map<String, String> body = {
        "business": businessId,
        "rating": rating.value.toString(),
        "title": titleCtrl.text.trim(),
        "description": descCtrl.text.trim(),
        "liked": likedCtrls
            .map((c) => c.text.trim())
            .where((e) => e.isNotEmpty)
            .join(','),
        "disliked": dislikedCtrls
            .map((c) => c.text.trim())
            .where((e) => e.isNotEmpty)
            .join(','),
      };

      // Prepare photo if selected
      List<MultipartBody> files = [];
      if (selectedPhoto.value != null) {
        files.add(MultipartBody("photos", File(selectedPhoto.value!.path)));
      }

      // API call
      final response = await ApiClient.postMultipartData(
        ApiConstants.postUserReview,
        body,
        multipartBody: files,
      );

      log("====>response review ${response.body}");

      // ⭐ Success
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              "Review submitted successfully!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Get.back(result: {
          "success": true,
          "message": "Review submitted successfully!"
        });

      }
      // ⭐ Already reviewed
      else if (response.statusCode == 409) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              "You have already reviewed this business. You can update your existing review instead.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // ⭐ Other errors
      else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              "Submission failed: ${response.statusText}",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
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

