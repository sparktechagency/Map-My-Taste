class GetFavouritesModel {
  final int? code;
  final bool? success;
  final String? message;
  final List<FavouriteDataList>? data;

  GetFavouritesModel({
    this.code,
    this.success,
    this.message,
    this.data,
  });

  factory GetFavouritesModel.fromJson(Map<String, dynamic> json) {
    return GetFavouritesModel(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FavouriteDataList.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class FavouriteDataList {
  final String? id;
  final String? user;
  final String? businessType;
  final String? googlePlaceId;
  final String? createdAt;
  final String? updatedAt;
  final Business? business;

  FavouriteDataList({
    this.id,
    this.user,
    this.businessType,
    this.googlePlaceId,
    this.createdAt,
    this.updatedAt,
    this.business,
  });

  factory FavouriteDataList.fromJson(Map<String, dynamic> json) {
    return FavouriteDataList(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      businessType: json['businessType'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      business: json['business'] != null
          ? Business.fromJson(json['business'])
          : null,
    );
  }
}

class Business {
  final String? id;
  final String? googlePlaceId;
  final String? name;
  final String? category;
  final String? description;
  final Location? location;
  final Contact? contact;
  final String? priceRange;
  final double? rating;
  final int? totalReviews;
  final List<Photo>? photos;
  final BusinessHours? businessHours;
  final bool? isFromGoogle;
  final bool? isVerified;
  final String? businessStatus;

  Business({
    this.id,
    this.googlePlaceId,
    this.name,
    this.category,
    this.description,
    this.location,
    this.contact,
    this.priceRange,
    this.rating,
    this.totalReviews,
    this.photos,
    this.businessHours,
    this.isFromGoogle,
    this.isVerified,
    this.businessStatus,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      contact: json['contact'] != null ? Contact.fromJson(json['contact']) : null,
      priceRange: json['priceRange'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e))
          .toList() ?? [],
      businessHours: json['businessHours'] != null
          ? BusinessHours.fromJson(json['businessHours'])
          : null,
      isFromGoogle: json['isFromGoogle'] ?? false,
      isVerified: json['isVerified'] ?? false,
      businessStatus: json['businessStatus'] ?? '',
    );
  }
}

class BusinessHours {
  final bool? isOpen;
  final List<String>? weekdayText;

  BusinessHours({this.isOpen, this.weekdayText});

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      isOpen: json['isOpen'] ?? false,
      weekdayText: (json['weekdayText'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }
}

class Location {
  final String? type;
  final List<double>? coordinates;
  final Address? address;

  Location({
    this.type,
    this.coordinates,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? coordinatesList = json['coordinates'] as List<dynamic>?;

    return Location(
      type: json['type'] as String?,
      coordinates: coordinatesList
          ?.map((e) => (e as num? ?? 0.0).toDouble())
          .toList(growable: false) ??
          [],
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}


class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? formattedAddress;

  Address({
    this.street,
    this.city,
    this.state,
    this.country,
    this.formattedAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      formattedAddress: json['formattedAddress'] ?? '',
    );
  }
}

class Contact {
  final String? phone;
  final String? website;

  Contact({
    this.phone,
    this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
    );
  }
}

class Photo {
  final String? photoUrl;
  final String? photoReference;
  final int? width;
  final int? height;

  Photo({
    this.photoUrl,
    this.photoReference,
    this.width,
    this.height,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      photoUrl: json['photoUrl'] ?? '',
      photoReference: json['photoReference'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}


class DeleteFavouriteResponse {
  final int? code;
  final bool? success;
  final String? message;

  DeleteFavouriteResponse({
    this.code,
    this.success,
    this.message,
  });

  factory DeleteFavouriteResponse.fromJson(Map<String, dynamic> json) {
    return DeleteFavouriteResponse(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

////  GetSIngle Favourite \\\\\


class GetSingleFavouriteModel {
  final int? code;
  final bool? success;
  final String? message;
  final SingleFavouriteData? data;

  GetSingleFavouriteModel({
    this.code,
    this.success,
    this.message,
    this.data,
  });

  factory GetSingleFavouriteModel.fromJson(Map<String, dynamic> json) {
    return GetSingleFavouriteModel(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? SingleFavouriteData.fromJson(json['data'])
          : null,
    );
  }
}

class SingleFavouriteData {
  final String? id;
  final FavouriteUser? user;
  final String? business;
  final String? businessType;
  final String? googlePlaceId;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  SingleFavouriteData({
    this.id,
    this.user,
    this.business,
    this.businessType,
    this.googlePlaceId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleFavouriteData.fromJson(Map<String, dynamic> json) {
    return SingleFavouriteData(
      id: json['_id'] ?? '',
      user: json['user'] != null
          ? FavouriteUser.fromJson(json['user'])
          : null,
      business: json['business'] ?? '',
      businessType: json['businessType'] ?? '',
      googlePlaceId: json['googlePlaceId'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class FavouriteUser {
  final String? id;
  final String? fullName;
  final String? displayName;
  final bool? isAdmin;

  FavouriteUser({
    this.id,
    this.fullName,
    this.displayName,
    this.isAdmin,
  });

  factory FavouriteUser.fromJson(Map<String, dynamic> json) {
    return FavouriteUser(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      displayName: json['displayName'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}
