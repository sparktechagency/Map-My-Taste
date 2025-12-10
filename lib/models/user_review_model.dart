import 'package:dio/dio.dart';

class UserReviewModel {
  final String? id;
  final String business;
  final String? businessType;
  final String? user;
  final int rating;
  final String title;
  final String description;
  final List<String> liked;
  final List<String> disliked;
  final List<ReviewPhoto>? photos;
  final int? likesCount;
  final bool? isActive;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Only for sending request (Multipart files)
  final List<MultipartFile>? photoFiles;

  UserReviewModel({
    this.id,
    required this.business,
    this.businessType,
    this.user,
    required this.rating,
    required this.title,
    required this.description,
    required this.liked,
    required this.disliked,
    this.photos,
    this.likesCount,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.photoFiles,
  });

  // ---------- PARSE API RESPONSE ----------
  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      id: json["_id"] ?? json["id"],
      business: json["business"],
      businessType: json["businessType"],
      user: json["user"],
      rating: json["rating"],
      title: json["title"],
      description: json["description"],
      liked: List<String>.from(json["liked"] ?? []),
      disliked: List<String>.from(json["disliked"] ?? []),
      photos: json["photos"] != null
          ? (json["photos"] as List)
          .map((p) => ReviewPhoto.fromJson(p))
          .toList()
          : [],
      likesCount: json["likesCount"],
      isActive: json["isActive"],
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }

  // ---------- FOR SENDING REVIEW (POST REQUEST) ----------
  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(MapEntry("business", business));
    formData.fields.add(MapEntry("rating", rating.toString()));
    formData.fields.add(MapEntry("title", title));
    formData.fields.add(MapEntry("description", description));

    // multiple liked[] fields
    for (var item in liked) {
      formData.fields.add(MapEntry("liked", item));
    }

    // multiple disliked[] fields
    for (var item in disliked) {
      formData.fields.add(MapEntry("disliked", item));
    }

    // photos
    if (photoFiles != null) {
      for (var pf in photoFiles!) {
        formData.files.add(MapEntry("photos", pf));
      }
    }

    return formData;
  }
}

// =============== PHOTO MODEL (FROM API RESPONSE) ===============
class ReviewPhoto {
  final String url;
  final DateTime uploadedAt;

  ReviewPhoto({
    required this.url,
    required this.uploadedAt,
  });

  factory ReviewPhoto.fromJson(Map<String, dynamic> json) {
    return ReviewPhoto(
      url: json["url"],
      uploadedAt: DateTime.parse(json["uploadedAt"]),
    );
  }
}
