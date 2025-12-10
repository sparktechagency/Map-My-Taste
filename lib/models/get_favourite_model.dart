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
      contact:
      json['contact'] != null ? Contact.fromJson(json['contact']) : null,
      priceRange: json['priceRange'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e))
          .toList() ??
          [],
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

