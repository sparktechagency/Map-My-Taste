class AddFavouriteModel {
  int? code;
  bool? success;
  String? message;
  FavouriteData? data;

  AddFavouriteModel({this.code, this.success, this.message, this.data});

  factory AddFavouriteModel.fromJson(Map<String, dynamic> json) {
    return AddFavouriteModel(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? FavouriteData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class FavouriteData {
  String? id;
  User? user;
  String? business;
  String? businessType;
  String? googlePlaceId;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? v;

  FavouriteData({
    this.id,
    this.user,
    this.business,
    this.businessType,
    this.googlePlaceId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FavouriteData.fromJson(Map<String, dynamic> json) {
    return FavouriteData(
      id: json['_id'] ?? json['id'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      business: json['business'] ?? '',
      businessType: json['businessType'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'business': business,
      'businessType': businessType,
      'googlePlaceId': googlePlaceId,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class User {
  String? id;
  String? fullName;
  String? displayName;
  bool? isAdmin;

  User({this.id, this.fullName, this.displayName, this.isAdmin});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      displayName: json['displayName'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'displayName': displayName,
      'isAdmin': isAdmin,
    };
  }
}
