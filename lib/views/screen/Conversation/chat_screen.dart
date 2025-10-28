import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_icons.dart';
import '../../../../../../utils/app_images.dart';
import '../../base/custom_text.dart';
import '../../base/custom_text_field.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final StreamController _streamController = StreamController();
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  Uint8List? _image;
  File? selectedImage;

  List<Map<String, String>> messageList = [
    {
      "name": "Alice",
      "status": "sender",
      "message": "Hey there!",
      "image": AppImages.onboard1,
      "date": "2025-12-24",
    },
    {
      "name": "Bob",
      "status": "receiver",
      "message": "Hi, what's up?",
      "image": AppImages.onboard1,
      "date": "2025-12-24",
    },
    {
      "name": "Charlie",
      "status": "sender",
      "message": "Just checking in.",
      "image": AppImages.onboard1,
      "date": "2025-12-24",
    },
    {
      "name": "David",
      "status": "receiver",
      "message": "Everything's good here, thanks!",
      "image": AppImages.onboard1,
      "date": "2025-12-23",
    },
    {
      "name": "Eve",
      "status": "sender",
      "message": "Cool.",
      "image": AppImages.onboard1,
      "date": "2025-12-23",
    },
    {
      "name": "Frank",
      "status": "receiver",
      "message": "Did you see the latest update?",
      "image": AppImages.onboard1,
      "date": "2025-12-22",
    },
    // Add more messages here with different dates if needed
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        titleSpacing: 0.w,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: CustomText(
          text: 'Motin miar Pizza Ghur',
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
        actions: [
          _popupMenuButton(),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GroupedListView<Map<String, String>, String>(
                    controller: _scrollController,
                    elements: messageList,
                    groupBy: (message) => message['date']!,
                    groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          groupByValue,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                    itemBuilder: (context, message) {
                      return message['status'] == "sender"
                          ? senderBubble(context, message)
                          : receiverBubble(context, message);
                    },
                  ),
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
      //==============================> Sent Message Text Field <===================================
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: CustomTextField(
          borderColor: AppColors.primaryColor,
          controller: messageController,
          hintText: "Write your message...",
          suffixIcons: InkWell(
            onTap: (){
              Map<String, String> newMessage = {
                "name": "John",
                "status": "sender",
                "message": messageController.text,
                "image": AppImages.onboard1,
                "date": "2025-12-24",
              };
              if (messageController.text.isNotEmpty) {
                messageList.add(newMessage);
                _streamController.sink.add(messageList);
                messageController.clear();
                _image = null;
              }
              setState(() {});
            },
              child: SvgPicture.asset(AppIcons.send)),
        ),
      ),
    );
  }
  //==============================> Receiver Bubble Message <===================================
  receiverBubble(BuildContext context, Map<String, String> message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Container(
          height: 38.h,
          width: 38.w,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(message['image']!, fit: BoxFit.cover),
        ),
        SizedBox(width: 8.w),*/
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
            backGroundColor: AppColors.fillColor,
            margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.57.w
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                   text: message['message'] ?? "",
                   fontSize: 14.sp,
                    textAlign: TextAlign.start,
                    maxLine: 500,
                    bottom: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: CustomText(
                         text:  '2:00 am',
                            fontSize: 12.sp,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  //==============================> Sender Bubble Message <===================================
  senderBubble(BuildContext context, Map<String, String> message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: ChatBubble(
            clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
            backGroundColor: AppColors.primaryColor,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.57,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: message['message'] ?? "",
                    textAlign: TextAlign.start,
                    maxLine: 500,
                    bottom: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: CustomText(
                          text:  '2:00 am',
                          fontSize: 12.sp,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
       /* SizedBox(width: 8.w),
        Container(
          height: 38.h,
          width: 38.w,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(message['image']!, fit: BoxFit.cover),
        ),*/
      ],
    );
  }

  Future openGallery() async {
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      selectedImage = File(pickImage!.path);
      _image = File(pickImage.path).readAsBytesSync();
    });
  }

  //==============================> Popup Menu Button <===================================

  PopupMenuButton<int> _popupMenuButton() {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      icon: SvgPicture.asset(AppIcons.dot, color: Colors.white),
      onSelected: (int result) {
        print(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.mute),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Mute'.tr,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.delete),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Delete'.tr,
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              SvgPicture.asset(AppIcons.block),
              SizedBox(width: 8.w),
              CustomText(
                text: 'Block'.tr,
              ),
            ],
          ),
        ),
      ],
      color: AppColors.fillColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
