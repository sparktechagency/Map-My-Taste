class CategoryQueryModel {
  int code;
  bool success;
  String message;
  List<CategoryData> data;

  CategoryQueryModel({
    this.code = 0,
    this.success = false,
    this.message = '',
    this.data = const [],
  });

  factory CategoryQueryModel.fromJson(Map<String, dynamic> json) {
    return CategoryQueryModel(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CategoryData>.from(
          json['data'].map((e) => CategoryData.fromJson(e)))
          : [],
    );
  }
}

class CategoryData {
  String id;
  String name;
  String category;
  String description;
  LocationModel location;
  List<PhotoModel> photos;
  StatsModel stats;
  GoogleModel google;
  double distance;
  bool isVerified;
  bool isActive;
  bool isDeleted;
  String createdAt;
  String updatedAt;

  CategoryData({
    this.id = '',
    this.name = '',
    this.category = '',
    this.description = '',
    LocationModel? location,
    this.photos = const [],
    StatsModel? stats,
    GoogleModel? google,
    this.distance = 0.0,
    this.isVerified = false,
    this.isActive = false,
    this.isDeleted = false,
    this.createdAt = '',
    this.updatedAt = '',
  })  : location = location ?? LocationModel(),
        stats = stats ?? StatsModel(),
        google = google ?? GoogleModel();

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : LocationModel(),
      photos: json['photos'] != null
          ? List<PhotoModel>.from(
          json['photos'].map((e) => PhotoModel.fromJson(e)))
          : [],
      stats: json['stats'] != null
          ? StatsModel.fromJson(json['stats'])
          : StatsModel(),
      google: json['google'] != null
          ? GoogleModel.fromJson(json['google'])
          : GoogleModel(),
      distance: (json['distance'] ?? 0).toDouble(),
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class LocationModel {
  String type;
  List<double> coordinates;
  AddressModel address;

  LocationModel({
    this.type = '',
    this.coordinates = const [],
    AddressModel? address,
  }) : address = address ?? AddressModel();

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] ?? '',
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((e) => e.toDouble()))
          : [],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : AddressModel(),
    );
  }
}

class AddressModel {
  String street;
  String city;
  String state;
  String country;
  String formattedAddress;

  AddressModel({
    this.street = '',
    this.city = '',
    this.state = '',
    this.country = '',
    this.formattedAddress = '',
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      formattedAddress: json['formattedAddress'] ?? '',
    );
  }
}

class PhotoModel {
  String url;
  String uploadedBy;
  String uploadedAt;
  bool isMain;

  PhotoModel({
    this.url = '',
    this.uploadedBy = '',
    this.uploadedAt = '',
    this.isMain = false,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      url: json['url'] ?? '',
      uploadedBy: json['uploadedBy'] ?? '',
      uploadedAt: json['uploadedAt'] ?? '',
      isMain: json['isMain'] ?? false,
    );
  }
}

class StatsModel {
  int totalReviews;
  double averageRating;
  int totalVisits;
  int totalFavorites;

  StatsModel({
    this.totalReviews = 0,
    this.averageRating = 0.0,
    this.totalVisits = 0,
    this.totalFavorites = 0,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalVisits: json['totalVisits'] ?? 0,
      totalFavorites: json['totalFavorites'] ?? 0,
    );
  }
}

class GoogleModel {
  String placeId;
  double rating;
  int totalRatings;

  GoogleModel({
    this.placeId = '',
    this.rating = 0.0,
    this.totalRatings = 0,
  });

  factory GoogleModel.fromJson(Map<String, dynamic> json) {
    return GoogleModel(
      placeId: json['placeId'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
    );
  }
}


