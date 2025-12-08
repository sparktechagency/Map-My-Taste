class SearchModel {
  final int code;
  final bool success;
  final String message;
  final List<Business> data;
  final Meta meta;

  SearchModel({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    code: json["code"] ?? 0,
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    data: json["data"] != null
        ? List<Business>.from(
        (json["data"] as List).map((x) => Business.fromJson(x)))
        : [],
    meta: json["meta"] != null ? Meta.fromJson(json["meta"]) : Meta.empty(),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta.toJson(),
  };
}

class Business {
  final String id;
  final String googlePlaceId;
  final String name;
  final String category;
  final String description;
  final Location location;
  final Contact? contact;
  final String? priceRange;
  final double? rating;
  final int? totalReviews;
  final List<Photo>? photos;
  final BusinessHours? businessHours;
  final double? distance;
  final bool? isFromGoogle;
  final bool? isVerified;
  final String? businessStatus;
  final String? source;
  final bool? isOfflineAdded;
  final String? verificationStatus;
  final bool? needsVerification;

  Business({
    required this.id,
    required this.googlePlaceId,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    this.contact,
    this.priceRange,
    this.rating,
    this.totalReviews,
    this.photos,
    this.businessHours,
    this.distance,
    this.isFromGoogle,
    this.isVerified,
    this.businessStatus,
    this.source,
    this.isOfflineAdded,
    this.verificationStatus,
    this.needsVerification,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    id: json["id"] ?? '',
    googlePlaceId: json["googlePlaceId"] ?? '',
    name: json["name"] ?? 'Unknown Name',
    category: json["category"] ?? 'Unknown Category',
    description: json["description"] ?? '',
    location: json["location"] != null
        ? Location.fromJson(json["location"])
        : Location.empty(),
    contact: json["contact"] != null ? Contact.fromJson(json["contact"]) : null,
    priceRange: json["priceRange"],
    rating: (json["rating"] != null) ? json["rating"].toDouble() : null,
    totalReviews: json["totalReviews"],
    photos: json["photos"] != null
        ? List<Photo>.from((json["photos"] as List).map((x) => Photo.fromJson(x)))
        : null,
    businessHours: json["businessHours"] != null
        ? BusinessHours.fromJson(json["businessHours"])
        : null,
    distance: (json["distance"] != null) ? json["distance"].toDouble() : null,
    isFromGoogle: json["isFromGoogle"],
    isVerified: json["isVerified"],
    businessStatus: json["businessStatus"],
    source: json["source"],
    isOfflineAdded: json["isOfflineAdded"],
    verificationStatus: json["verificationStatus"],
    needsVerification: json["needsVerification"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "googlePlaceId": googlePlaceId,
    "name": name,
    "category": category,
    "description": description,
    "location": location.toJson(),
    "contact": contact?.toJson(),
    "priceRange": priceRange,
    "rating": rating,
    "totalReviews": totalReviews,
    "photos": photos != null
        ? List<dynamic>.from(photos!.map((x) => x.toJson()))
        : null,
    "businessHours": businessHours?.toJson(),
    "distance": distance,
    "isFromGoogle": isFromGoogle,
    "isVerified": isVerified,
    "businessStatus": businessStatus,
    "source": source,
    "isOfflineAdded": isOfflineAdded,
    "verificationStatus": verificationStatus,
    "needsVerification": needsVerification,
  };
}

class Location {
  final String type;
  final List<double> coordinates;
  final Address address;

  Location({required this.type, required this.coordinates, required this.address});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"] ?? '',
    coordinates: json["coordinates"] != null
        ? List<double>.from(json["coordinates"].map((x) => x.toDouble()))
        : [0.0, 0.0],
    address: json["address"] != null ? Address.fromJson(json["address"]) : Address.empty(),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates,
    "address": address.toJson(),
  };

  factory Location.empty() => Location(
    type: '',
    coordinates: [0.0, 0.0],
    address: Address.empty(),
  );
}

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? formattedAddress;

  Address({this.street, this.city, this.state, this.country, this.formattedAddress});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    formattedAddress: json["formattedAddress"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "country": country,
    "formattedAddress": formattedAddress,
  };

  factory Address.empty() => Address(
    street: '',
    city: '',
    state: '',
    country: '',
    formattedAddress: '',
  );
}

class Contact {
  final String phone;

  Contact({required this.phone});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    phone: json["phone"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };
}

class Photo {
  final String photoUrl;
  final String photoReference;
  final int width;
  final int height;

  Photo({
    required this.photoUrl,
    required this.photoReference,
    required this.width,
    required this.height,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    photoUrl: json["photoUrl"] ?? '',
    photoReference: json["photoReference"] ?? '',
    width: json["width"] is int
        ? json["width"]
        : int.tryParse(json["width"]?.toString() ?? '') ?? 0,
    height: json["height"] is int
        ? json["height"]
        : int.tryParse(json["height"]?.toString() ?? '') ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "photoUrl": photoUrl,
    "photoReference": photoReference,
    "width": width,
    "height": height,
  };
}

class BusinessHours {
  final bool isOpen;

  BusinessHours({required this.isOpen});

  factory BusinessHours.fromJson(Map<String, dynamic> json) => BusinessHours(
    isOpen: json["isOpen"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "isOpen": isOpen,
  };
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"] is int
        ? json["total"]
        : int.tryParse(json["total"]?.toString() ?? '') ?? 0,
    page: json["page"] is int
        ? json["page"]
        : int.tryParse(json["page"]?.toString() ?? '') ?? 1,
    limit: json["limit"] is int
        ? json["limit"]
        : int.tryParse(json["limit"]?.toString() ?? '') ?? 10,
    totalPages: json["totalPages"] is int
        ? json["totalPages"]
        : int.tryParse(json["totalPages"]?.toString() ?? '') ?? 1,
    hasNext: json["hasNext"] ?? false,
    hasPrev: json["hasPrev"] ?? false,
  );

  // Factory for safe empty/default Meta
  factory Meta.empty() => Meta(
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 1,
    hasNext: false,
    hasPrev: false,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "hasNext": hasNext,
    "hasPrev": hasPrev,
  };
}

