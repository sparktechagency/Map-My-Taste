import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_my_taste/utils/app_colors.dart';
import 'package:map_my_taste/utils/app_icons.dart';
import 'package:map_my_taste/utils/app_images.dart';
import 'package:map_my_taste/utils/app_strings.dart';
import 'package:map_my_taste/views/base/custom_network_image.dart';
import 'package:map_my_taste/views/base/custom_text.dart';
import 'package:map_my_taste/views/base/custom_text_field.dart';
import '../../base/bottom_menu..dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=======================================> App Bar Section <===================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(AppImages.logo, width: 162.w, height: 37.h),
            Spacer(),
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.notification,
                width: 24.w,
                height: 24.h,
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                AppIcons.message,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
      //=======================================> Body Section <===================================
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //=======================================> Search And Filter Row <===================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 328.w,
                    child: CustomTextField(
                      controller: searchCTRL,
                      hintText: AppStrings.searchForRestaurants.tr,
                      prefixIcon: SvgPicture.asset(AppIcons.search),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(AppIcons.filter),
                  ),
                ],
              ),
              //=======================================> Post Card Section <===================================
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return PostCard();
              },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fillColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //=========================> Name and Image Poster <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                CustomNetworkImage(
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKbe4FsXoLVUtq5YPBCHgiSX4Owqshk79Ejw&s',
                    height: 64.h, width: 64.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Nura',
                        fontSize: 20.sp,
                        textAlign: TextAlign.start,
                        maxLine: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: '25 Aug 2024',
                        fontSize: 16.sp,
                        color: AppColors.greyColor,

                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Divider(thickness: 0.3, color: AppColors.greyColor),
          //=========================> Restaurants Name and Image Ratings <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                CustomNetworkImage(
                  imageUrl: 'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                  height: 64.h, width: 64.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: 'Motin miar Pizza Ghar',
                            fontSize: 20.sp,
                            textAlign: TextAlign.start,
                            maxLine: 2,
                            fontWeight: FontWeight.w700,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              SizedBox(width: 5),
                              CustomText(
                               text:  '4.9',
                               color: AppColors.greyColor, fontSize: 16.sp
                              ),
                            ],
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: AppStrings.restaurants.tr,
                            fontSize: 16.sp,
                            color: AppColors.greyColor,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                              SizedBox(width: 5.w),
                              CustomText(
                                text:  '0.5 km',
                               color: AppColors.greyColor, fontSize: 16.sp
                              ),
                              
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.secondaryButtonColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              child: CustomText(
                                text: AppStrings.open.tr,
                              ),
                            ),
                          )



                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 0.3, color: AppColors.greyColor),
          //=====================================> Description <===============================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: CustomText(
             text:  'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
              color: Colors.white, fontSize: 14,
              maxLine: 2,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
          //=====================================> Image <===============================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: SizedBox(
              height: 150.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CustomNetworkImage(imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                      height: 88.h, width: 150.w,
                  borderRadius: BorderRadius.circular(12.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomNetworkImage(imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                    height: 88.h, width: 150.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomNetworkImage(imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                    height: 88.h, width: 150.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomNetworkImage(imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                    height: 88.h, width: 150.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ],
              ),
            ),
          ),
          //=====================================> Like And Comment <===============================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){},
                        child: Icon(Icons.thumb_up_alt_outlined, color: AppColors.greyColor, size: 20)),
                    SizedBox(width: 5),
                    CustomText(
                     text: '506 Likes',
                     color: AppColors.greyColor, fontSize: 16.sp
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Row(
                  children: [
                    InkWell(
                        onTap: (){},
                        child: Icon(Icons.insert_comment_outlined, color:AppColors.greyColor, size: 20)),
                    SizedBox(width: 5),
                    CustomText(
                     text: '456 Comments',
                      color: AppColors.greyColor, fontSize: 16.sp
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/



class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isDescriptionExpanded = false;
  int likeCount = 506;

  // Sample comment data
  final List<Map<String, String>> comments = [
    {
      'name': 'Nura',
      'comment': 'Great post! Really loved the pizza.',
      'avatar': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKbe4FsXoLVUtq5YPBCHgiSX4Owqshk79Ejw&s'
    },
    {
      'name': 'John',
      'comment': 'Looking forward to trying this place!',
      'avatar': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKbe4FsXoLVUtq5YPBCHgiSX4Owqshk79Ejw&s'
    },
  ];

  TextEditingController _commentController = TextEditingController();

  void _toggleDescription() {
    setState(() {
      isDescriptionExpanded = !isDescriptionExpanded;
    });
  }

  void _incrementLikeCount() {
    setState(() {
      likeCount++;
    });
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comments', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 10),
              // Display the list of comments
              Expanded(
                child: ListView(
                  children: comments.map((comment) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(comment['avatar']!),
                      ),
                      title: Text(comment['name']!),
                      subtitle: Text(comment['comment']!),
                    );
                  }).toList(),
                ),
              ),
              // Add the TextField for new comment
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Write a comment...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 10),
              // Submit button to add the new comment
              ElevatedButton(
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    setState(() {
                      // Add new comment
                      comments.add({
                        'name': 'You',
                        'comment': _commentController.text,
                        'avatar': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKbe4FsXoLVUtq5YPBCHgiSX4Owqshk79Ejw&s'
                      });
                      // Clear the text field after submission
                      _commentController.clear();
                    });
                    Navigator.pop(context); // Close the bottom sheet
                  }
                },
                child: Text('Submit Comment'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fillColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //=========================> Name and Image Poster <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                CustomNetworkImage(
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKbe4FsXoLVUtq5YPBCHgiSX4Owqshk79Ejw&s',
                  height: 64.h, width: 64.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Nura',
                        fontSize: 20.sp,
                        textAlign: TextAlign.start,
                        maxLine: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: '25 Aug 2024',
                        fontSize: 16.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 0.3, color: AppColors.greyColor),

          //=========================> Restaurant Info <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                CustomNetworkImage(
                  imageUrl: 'https://plus.unsplash.com/premium_photo-1661883237884-263e8de8869b?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000',
                  height: 64.h, width: 64.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: 'Motin miar Pizza Ghar',
                            fontSize: 20.sp,
                            textAlign: TextAlign.start,
                            maxLine: 2,
                            fontWeight: FontWeight.w700,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 20),
                              SizedBox(width: 5),
                              CustomText(
                                  text:  '4.9',
                                  color: AppColors.greyColor, fontSize: 16.sp
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: AppStrings.restaurants.tr,
                            fontSize: 16.sp,
                            color: AppColors.greyColor,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                              SizedBox(width: 5.w),
                              CustomText(
                                  text:  '0.5 km',
                                  color: AppColors.greyColor, fontSize: 16.sp
                              ),
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.secondaryButtonColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                              child: CustomText(
                                text: AppStrings.open.tr,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 0.3, color: AppColors.greyColor),

          //=====================> Description with "More" Button <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: isDescriptionExpanded
                      ? 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
                      : 'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
                  color: Colors.white,
                  fontSize: 14,
                  maxLine: isDescriptionExpanded ? 150 : 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                GestureDetector(
                  onTap: _toggleDescription,
                  child: CustomText(
                    text: isDescriptionExpanded ? 'Show Less' : 'Show More',
                    color: AppColors.secondaryButtonColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          //=====================> Image Carousel <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: SizedBox(
              height: 150.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CustomNetworkImage(
                    imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                    height: 88.h, width: 150.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomNetworkImage(
                    imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                    height: 88.h, width: 150.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  SizedBox(width: 8.w),
                  CustomNetworkImage(
                    imageUrl: 'https://images.deliveryhero.io/image/fd-bd/LH/cda0-listing.jpg',
                    height: 88.h, width: 150.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ],
              ),
            ),
          ),

          //=====================> Like And Comment <======================
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: _incrementLikeCount,
                      child: Icon(Icons.thumb_up_alt_outlined, color: AppColors.greyColor, size: 20),
                    ),
                    SizedBox(width: 5),
                    CustomText(
                        text: '$likeCount Likes',
                        color: AppColors.greyColor, fontSize: 16.sp
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Row(
                  children: [
                    InkWell(
                        onTap: _showCommentSheet,
                        child: Icon(Icons.insert_comment_outlined, color: AppColors.greyColor, size: 20)),
                    SizedBox(width: 5),
                    CustomText(
                        text: '456 Comments',
                        color: AppColors.greyColor, fontSize: 16.sp
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
