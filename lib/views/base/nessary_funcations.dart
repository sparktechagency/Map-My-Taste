/*
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project_template/views/base/custom_button.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import 'custom_text.dart';

class NessaryFuncations extends StatefulWidget {
  const NessaryFuncations({super.key});

  @override
  State<NessaryFuncations> createState() => _NessaryFuncationsState();
}

class _NessaryFuncationsState extends State<NessaryFuncations> {
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  File? selectedImage;
  RxString imagesPath = ''.obs;
  RxString imagesPaths = ''.obs;
  Uint8List? _image;
  File? selectedIMage;
  bool isChecked = false;
  String? selectedGender;
  String? selectedSports;
  final List<String> sports = [
    'Boxen',
    'Kick boxen',
    'Muay Thai',
    'K-1',
    'Kyokushin Karate'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //=============================> Phone number Text Field <====================
          CustomText(
            text: 'Phone number',
            bottom: 4.h,
          ),
          IntlPhoneField(
            decoration: InputDecoration(
              hintText: "Phone number",
              contentPadding: EdgeInsets.symmetric(horizontal: 15.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.r)),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 1.w),
              ),
            ),
            showCountryFlag: true,
            initialCountryCode: 'US',
            flagsButtonMargin: EdgeInsets.only(left: 10.w),
            disableLengthCheck: true,
            dropdownIconPosition: IconPosition.trailing,
            onChanged: (phone) {
              print("Phone===============> ${phone.completeNumber}");
            },
          ),
          //=============================> Dropdown Button with Validation Text Field <====================
          FormField<String>(
            validator: (value) {
              if (selectedSports == null || selectedSports!.isEmpty) {
                return 'Please select a sport';
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.fillColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color:
                            state.hasError ? Colors.red : AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        focusColor: Colors.white,
                        value: selectedSports,
                        dropdownColor: AppColors.whiteColor,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                        ),
                        menuMaxHeight: 300.h, // Adjusts dropdown menu height
                        borderRadius: BorderRadius.circular(8.r),
                        hint: CustomText(
                          text: 'Select your sports'.tr,
                          fontSize: 14.sp,
                          color: AppColors.whiteColor,
                        ),
                        icon: SvgPicture.asset(
                          AppIcons.cardIcon,
                          color: AppColors.whiteColor,
                        ),
                        isExpanded: true,
                        items: sports.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: CustomText(
                              text: value,
                              fontSize: 14.sp,
                              color: AppColors.backgroundColor,
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return sports.map((String value) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: CustomText(
                                text: value,
                                fontSize: 14.sp,
                                color: AppColors.whiteColor,
                              ),
                            );
                          }).toList();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            selectedSports = newValue;
                            state.didChange(newValue);
                          });
                        },
                      ),
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: CustomText(
                        text: state.errorText!,
                        fontSize: 12.sp,
                        color: Colors.red,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

//====================================> Pick Image Gallery and Camera <====================
  void _showImagePickerOption() {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              //=========================> Pick Image Gallery <==================
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  // => _profileController.pickImage(ImageSource.gallery),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image,
                          size: 50.w, color: AppColors.primaryColor),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Gallery',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
              //=========================> Pick Image Camera <====================
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  // => _profileController.pickImage(ImageSource.camera),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt,
                          size: 50.w, color: AppColors.primaryColor),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: 'Camera',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  //==================================> Gallery <===============================
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }

//==================================> Camera <===============================
  Future _pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
    Get.back();
  }

  //==========================> Show Calender Function <=======================
  Future<void> _pickBirthDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
      setState(() {
        birthDayController.text =
            "${_getMonthName(pickedDate.month)} ${pickedDate.day}, ${pickedDate.year}";
      });
    }
  }

  // Helper function to convert month number to name
  String _getMonthName(int month) {
    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  //==========================> Show Country Name Function <=======================
  Future<void> _pickCountry(BuildContext context) async {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        backgroundColor: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        inputDecoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          countryController.text = country.name;
        });
      },
    );
  }

  //==========================> Checkbox Section Widget <=======================
  _checkboxSection() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          activeColor: AppColors.primaryColor,
          focusColor: AppColors.greyColor,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          side: BorderSide(
            color: isChecked ? AppColors.primaryColor : AppColors.primaryColor,
            width: 1.w,
          ),
        ),
        Text.rich(
          maxLines: 2,
          TextSpan(
            text: 'By creating an account, I accept \nthe ',
            style: TextStyle(fontSize: 14.w, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: 'Terms & Conditions',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //Get.toNamed(AppRoutes.termsConditionScreen);
                  },
              ),
              const TextSpan(text: ' & '),
              TextSpan(
                text: 'Privacy Policy.',
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //Get.toNamed(AppRoutes.privacyPolicyScreen);
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //===============================> Tow Type Image Picker <=============================
  Future pickTowTypeImage(ImageSource source, String type) async {
    final returnImage = await ImagePicker().pickImage(source: source);
    if (returnImage == null) return;
    selectedImage = File(returnImage.path);
    if (type == "font") {
      imagesPath.value = selectedImage!.path;
    } else {
      imagesPaths.value = selectedImage!.path;
    }
    //  image = File(returnImage.path).readAsBytesSync();
    //update();
    print('ImagesPath===========================>:${imagesPath.value}');
    //Get.back(); //
  }

//=========================> Gender Radio Button <================
  _genderRadioButton() {
    return Row(
      children: [
        InkWell(
          onTap: () => setState(() {
            selectedGender = 'Male';
          }),
          child: Row(
            children: [
              Radio<String>(
                value: 'Male',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.deepPurple;
                  }
                  return AppColors.primaryColor;
                }),
              ),
              CustomText(
                text: 'Male',
                fontSize: 14.sp,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => setState(() {
            selectedGender = 'Female';
          }),
          child: Row(
            children: [
              Radio<String>(
                value: 'Female',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.deepPurple;
                  }
                  return AppColors.primaryColor;
                }),
              ),
              CustomText(
                text: 'Female',
                fontSize: 14.sp,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => setState(() {
            selectedGender = 'Others';
          }),
          child: Row(
            children: [
              Radio<String>(
                value: 'Others',
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.deepPurple;
                  }
                  return AppColors.primaryColor;
                }),
              ),
              CustomText(
                text: 'Other',
                fontSize: 14.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  //===============================> Log Out Bottom Sheet <===============================
  _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
            border: Border(
                top: BorderSide(width: 2.w, color: AppColors.primaryColor)),
            color: AppColors.cardColor,
          ),
          height: 265,
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: 'Logout',
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
              ),
              SizedBox(
                  width: 115.w, child: Divider(color: AppColors.primaryColor)),
              SizedBox(height: 20.h),
              CustomText(
                text: 'Are you sure you want to log out?',
                fontSize: 16.sp,
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 115.w,
                      child: CustomButton(
                        onTap: () {
                          Get.back();
                        },
                        text: "No",
                        color: Colors.white,
                        textColor: AppColors.primaryColor,
                      )),
                  SizedBox(width: 16.w),
                  SizedBox(
                      width: 115.w,
                      child: CustomButton(
                          onTap: () {
                            // Get.offAllNamed(AppRoutes.signInScreen);
                          },
                          text: "Yes")),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //===============================> Show Clock Function <=======================
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

    if (pickedTime != null) {
      setState(() {
        final hours = pickedTime.hour % 12 == 0 ? 12 : pickedTime.hour % 12;
        final minutes = pickedTime.minute.toString().padLeft(2, '0');
        final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
        timeCtrl.text = "${hours.toString().padLeft(2, '0')}:$minutes $period";
      });
    }
  }

//================================> Popup Menu Button Method <=============================
  PopupMenuButton<int> _popupMenuButton() {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (int result) {
        if (result == 0) {
          print('Report selected');
        } else if (result == 1) {
          print('Block selected');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.report, color: Colors.black54),
              SizedBox(width: 10.w),
              const Text(
                'Report',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.block, color: Colors.black54),
              SizedBox(width: 10.w),
              const Text(
                'Block',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  //=============================> Vertical Divider <================================
  _verticalDivider() {
    return SizedBox(
      height: 40.h,
      child: VerticalDivider(
        color: AppColors.whiteColor,
        thickness: 4.4,
        width: 4.w,
      ),
    );
  }
}
*/
