import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';
import '../service/api_checker.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';
import '../utils/app_colors.dart';

class ProfileController extends GetxController {

  RxString profileImagePath = ''.obs;
  File? selectedImage;
  RxString imagesPath = ''.obs;
  String title = "Profile Screen";
  RxString profileImageUrl = ''.obs;
  RxString selectedGender = ''.obs;



  @override
  void onInit() {
    debugPrint("On Init  $title");
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    debugPrint("On onReady  $title");
    super.onReady();
  }


  //=============================> Get Account Data <===============================
  Rx<ProfileModel> profileModel = ProfileModel().obs;
  RxBool profileLoading = false.obs;
  getProfileData() async {
    profileLoading(true);
    var response = await ApiClient.getData(
      ApiConstants.getProfileDataEndPoint,
    );
    print("my response : ${response.body}");
    if (response.statusCode == 200) {
      profileModel.value = ProfileModel.fromJson(
        response.body['data'],
      );

      fullNameCTRL.text = profileModel.value.fullName ?? '';
      phoneCTRL.text = profileModel.value.phoneNumber ?? '';
      addressCTRL.text = profileModel.value.address?.street ?? '';
      // addressCTRL.text = [
      //   profileModel.value.address?.street,
      //   profileModel.value.address?.city,
      //   profileModel.value.address?.state,
      //   profileModel.value.address?.zipCode,
      //   profileModel.value.address?.country,
      // ]
      //     .where((e) => e != null && e.trim().isNotEmpty)
      //     .join(', ');

      selectedGender.value = profileModel.value.profile?.gender ?? '';
      profileImageUrl.value =
          profileModel.value.profile?.profilePicture?.url ?? '';

      profileLoading(false);
      update();
    } else {
      ApiChecker.checkApi(response);
      profileLoading(false);
      update();
    }
  }


  Future<void> submitProfile(BuildContext context) async {
    try {
      debugPrint("===== Submit Profile Started =====");

      // =======================> Image validation <=======================
      if (selectedImage != null) {
        final imageBytes = await selectedImage!.length();
        final sizeInMb = imageBytes / (1024 * 1024);
        debugPrint("Selected image size: ${sizeInMb.toStringAsFixed(2)} MB");

        if (sizeInMb > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image must be less than 1 MB'),
              backgroundColor: Colors.red,
            ),
          );
          debugPrint("Image validation failed: > 1 MB");
          return;
        }
      } else {
        debugPrint("No image selected");
      }

      // =======================> Prepare body <============================
      Map<String, String> body = {};
      if (fullNameCTRL.text.trim().isNotEmpty) {
        body['fullName'] = fullNameCTRL.text.trim();
      }
      if (phoneCTRL.text.trim().isNotEmpty) {
        body['phoneNumber'] = phoneCTRL.text.trim();
      }
      if (addressCTRL.text.trim().isNotEmpty) {
        body['address'] = addressCTRL.text.trim();
      }
      if (selectedGender.value.trim().isNotEmpty) {
        body['gender'] = selectedGender.value.trim();
      }

      debugPrint("Request Body: $body");

      // =======================> Multipart file <==========================
      List<MultipartBody> files = [];
      if (selectedImage != null) {
        files.add(MultipartBody('profilePicture', selectedImage!));
        debugPrint("Multipart file added: ${selectedImage!.path}");
      }

      // =======================> API call <===============================
      profileLoading(true);
      debugPrint("Sending API request...");

      var response = await ApiClient.putMultipartData(
        ApiConstants.getProfileDataEndPoint,
        body,
        multipartBody: files,
      );

      profileLoading(false);

      debugPrint("API Response Status: ${response.statusCode}");
      debugPrint("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profile updated successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        debugPrint("Profile updated successfully, refreshing profile data...");
        await getProfileData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile: ${response.statusText}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        ApiChecker.checkApi(response);
      }
    } catch (e, stack) {
      profileLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint("Exception caught in submitProfile: $e");
      debugPrint(stack.toString());
    }
  }



  //===============================> Edit Profile Screen <=============================
  final TextEditingController fullNameCTRL = TextEditingController();
  final TextEditingController phoneCTRL = TextEditingController();
  final TextEditingController addressCTRL = TextEditingController();
  final TextEditingController genderCTRL = TextEditingController();
  final TextEditingController dateBirthCTRL = TextEditingController();

  //===============================> Image Picker <=============================
  Future pickImage(ImageSource source) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedImage = File(returnImage.path);
    imagesPath.value = selectedImage!.path;
    //  image = File(returnImage.path).readAsBytesSync();
    update();
    print('ImagesPath===========================>:${imagesPath.value}');
    Get.back(); //
  }

  //==========================> Show Calender Function <=======================
  Future<void> pickBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(3050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onSurface: Colors.black, // Text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      dateBirthCTRL.text =
          "${pickedDate.month}-${pickedDate.day}-${pickedDate.year}";
    }
  }
}
