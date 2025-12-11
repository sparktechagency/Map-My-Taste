class BusinessDetailsModel {
  final int code;
  final bool success;
  final String message;
  final BusinessDetails? data; // nullable in case "data" is missing

  BusinessDetailsModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
  });

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      code: json["code"] ?? 0,
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null ? BusinessDetails.fromJson(json["data"]) : null,
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Business Details
// ────────────────────────────────────────────────────────────────

class BusinessDetails {
  final String id;
  final String googlePlaceId;
  final String name;
  final String category;
  final String description;
  final Location? location; // nullable
  final Contact? contact;   // nullable
  final String priceRange;
  final double rating;
  final int totalReviews;
  final List<BusinessPhoto> photos;
  final BusinessHours? businessHours; // nullable
  final bool isFromGoogle;
  final bool isVerified;
  final String businessStatus;

  BusinessDetails({
    required this.id,
    required this.googlePlaceId,
    required this.name,
    required this.category,
    required this.description,
    this.location,
    this.contact,
    required this.priceRange,
    required this.rating,
    required this.totalReviews,
    required this.photos,
    this.businessHours,
    required this.isFromGoogle,
    required this.isVerified,
    required this.businessStatus,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      id: json["id"] ?? "",
      googlePlaceId: json["googlePlaceId"] ?? "",
      name: json["name"] ?? "",
      category: json["category"] ?? "",
      description: json["description"] ?? "",
      location: json["location"] != null ? Location.fromJson(json["location"]) : null,
      contact: json["contact"] != null ? Contact.fromJson(json["contact"]) : null,
      priceRange: json["priceRange"] ?? "",
      rating: (json["rating"] ?? 0).toDouble(),
      totalReviews: json["totalReviews"] ?? 0,
      photos: (json["photos"] as List<dynamic>?)
          ?.map((e) => BusinessPhoto.fromJson(e))
          .toList() ??
          [],
      businessHours: json["businessHours"] != null
          ? BusinessHours.fromJson(json["businessHours"])
          : null,
      isFromGoogle: json["isFromGoogle"] ?? false,
      isVerified: json["isVerified"] ?? false,
      businessStatus: json["businessStatus"] ?? "",
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Location
// ────────────────────────────────────────────────────────────────

class Location {
  final String type;
  final List<double> coordinates; // [lng, lat]
  final Address? address; // nullable

  Location({
    required this.type,
    required this.coordinates,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"] ?? "",
      coordinates: (json["coordinates"] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
      address: json["address"] != null ? Address.fromJson(json["address"]) : null,
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Address
// ────────────────────────────────────────────────────────────────

// ────────────────────────────────────────────────────────────────
// Address (Updated)
// ────────────────────────────────────────────────────────────────

class Address {
  final String? street; // made nullable
  final String? city;   // made nullable
  final String? state;  // made nullable
  final String? country; // made nullable
  final String? formattedAddress; // made nullable

  Address({
    this.street,
    this.city,
    this.state,
    this.country,
    this.formattedAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json["street"],
      city: json["city"],
      state: json["state"],
      country: json["country"],
      formattedAddress: json["formattedAddress"],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Contact
// ────────────────────────────────────────────────────────────────

class Contact {
  final String? phone; // made nullable
  final String? website; // made nullable

  Contact({
    this.phone,
    this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json["phone"],
      website: json["website"],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Business Photo
// ────────────────────────────────────────────────────────────────

class BusinessPhoto {
  final String photoUrl;
  final String photoReference;
  final int? width; // made nullable
  final int? height; // made nullable

  BusinessPhoto({
    required this.photoUrl,
    required this.photoReference,
    this.width,
    this.height,
  });

  factory BusinessPhoto.fromJson(Map<String, dynamic> json) {
    return BusinessPhoto(
      photoUrl: json["photoUrl"] ?? "",
      photoReference: json["photoReference"] ?? "",
      width: json["width"],
      height: json["height"],
    );
  }
}
// ────────────────────────────────────────────────────────────────
// Business Hours
// ────────────────────────────────────────────────────────────────

class BusinessHours {
  final bool isOpen;
  final List<String> weekdayText;

  BusinessHours({
    required this.isOpen,
    required this.weekdayText,
  });

  factory BusinessHours.fromJson(Map<String, dynamic> json) {
    return BusinessHours(
      isOpen: json["isOpen"] ?? false,
      weekdayText: (json["weekdayText"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }
}
