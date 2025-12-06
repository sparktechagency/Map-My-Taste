class ProfileModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final Address? address;
  final String? authRole;
  final String? status;
  final Profile? profile;
  final Preferences? preferences;
  final List<dynamic>? favoriteRestaurants;
  final List<dynamic>? visitedPlaces;
  final List<dynamic>? friends;
  final List<dynamic>? followers;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final bool? isResetPassword;
  final Stats? stats;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? firstName;
  final String? lastName;
  final DateTime? lastSeen;
  final String? profilePicture;
  final String? displayName;
  final bool? isAdmin;
  final bool? isVerified;
  final String? profileModelId;

  ProfileModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    this.authRole,
    this.status,
    this.profile,
    this.preferences,
    this.favoriteRestaurants,
    this.visitedPlaces,
    this.friends,
    this.followers,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.isResetPassword,
    this.stats,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.lastName,
    this.lastSeen,
    this.profilePicture,
    this.displayName,
    this.isAdmin,
    this.isVerified,
    this.profileModelId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["_id"],
    fullName: json["fullName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    authRole: json["authRole"],
    status: json["status"],
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
    preferences: json["preferences"] == null ? null : Preferences.fromJson(json["preferences"]),
    favoriteRestaurants: json["favoriteRestaurants"] == null ? [] : List<dynamic>.from(json["favoriteRestaurants"]!.map((x) => x)),
    visitedPlaces: json["visitedPlaces"] == null ? [] : List<dynamic>.from(json["visitedPlaces"]!.map((x) => x)),
    friends: json["friends"] == null ? [] : List<dynamic>.from(json["friends"]!.map((x) => x)),
    followers: json["followers"] == null ? [] : List<dynamic>.from(json["followers"]!.map((x) => x)),
    isEmailVerified: json["isEmailVerified"],
    isPhoneVerified: json["isPhoneVerified"],
    isResetPassword: json["isResetPassword"],
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    firstName: json["firstName"],
    lastName: json["lastName"],
    lastSeen: json["lastSeen"] == null ? null : DateTime.parse(json["lastSeen"]),
    profilePicture: json["profilePicture"],
    displayName: json["displayName"],
    isAdmin: json["isAdmin"],
    isVerified: json["isVerified"],
    profileModelId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "address": address?.toJson(),
    "authRole": authRole,
    "status": status,
    "profile": profile?.toJson(),
    "preferences": preferences?.toJson(),
    "favoriteRestaurants": favoriteRestaurants == null ? [] : List<dynamic>.from(favoriteRestaurants!.map((x) => x)),
    "visitedPlaces": visitedPlaces == null ? [] : List<dynamic>.from(visitedPlaces!.map((x) => x)),
    "friends": friends == null ? [] : List<dynamic>.from(friends!.map((x) => x)),
    "followers": followers == null ? [] : List<dynamic>.from(followers!.map((x) => x)),
    "isEmailVerified": isEmailVerified,
    "isPhoneVerified": isPhoneVerified,
    "isResetPassword": isResetPassword,
    "stats": stats?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "firstName": firstName,
    "lastName": lastName,
    "lastSeen": lastSeen?.toIso8601String(),
    "profilePicture": profilePicture,
    "displayName": displayName,
    "isAdmin": isAdmin,
    "isVerified": isVerified,
    "id": profileModelId,
  };
}

class Address {
  final Coordinates? coordinates;
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;

  Address({
    this.coordinates,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
    street: json["street"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zipCode"],
  );

  Map<String, dynamic> toJson() => {
    "coordinates": coordinates?.toJson(),
    "street": street,
    "city": city,
    "state": state,
    "country": country,
    "zipCode": zipCode,
  };
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class Preferences {
  final Notifications? notifications;
  final Privacy? privacy;
  final String? language;
  final String? timezone;
  final String? currency;

  Preferences({
    this.notifications,
    this.privacy,
    this.language,
    this.timezone,
    this.currency,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
    notifications: json["notifications"] == null ? null : Notifications.fromJson(json["notifications"]),
    privacy: json["privacy"] == null ? null : Privacy.fromJson(json["privacy"]),
    language: json["language"],
    timezone: json["timezone"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications?.toJson(),
    "privacy": privacy?.toJson(),
    "language": language,
    "timezone": timezone,
    "currency": currency,
  };
}

class Notifications {
  final bool? email;
  final bool? sms;
  final bool? push;
  final bool? marketing;

  Notifications({
    this.email,
    this.sms,
    this.push,
    this.marketing,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    email: json["email"],
    sms: json["sms"],
    push: json["push"],
    marketing: json["marketing"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "sms": sms,
    "push": push,
    "marketing": marketing,
  };
}

class Privacy {
  final String? profileVisibility;
  final bool? showEmail;
  final bool? showPhone;

  Privacy({
    this.profileVisibility,
    this.showEmail,
    this.showPhone,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
    profileVisibility: json["profileVisibility"],
    showEmail: json["showEmail"],
    showPhone: json["showPhone"],
  );

  Map<String, dynamic> toJson() => {
    "profileVisibility": profileVisibility,
    "showEmail": showEmail,
    "showPhone": showPhone,
  };
}

class Profile {
  final ProfilePicture? profilePicture;
  final String? gender;

  Profile({
    this.profilePicture,
    this.gender,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    profilePicture: json["profilePicture"] == null ? null : ProfilePicture.fromJson(json["profilePicture"]),
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "profilePicture": profilePicture?.toJson(),
    "gender": gender,
  };
}

class ProfilePicture {
  final String? filePath;
  final String? url;

  ProfilePicture({
    this.filePath,
    this.url,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => ProfilePicture(
    filePath: json["filePath"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "filePath": filePath,
    "url": url,
  };
}

class Stats {
  final int? numberOfPosts;
  final int? numberOfFriends;
  final int? numberOfFollowers;
  final int? numberOfPlacesVisited;
  final int? numberOfFavorites;
  final int? numberOfReviews;

  Stats({
    this.numberOfPosts,
    this.numberOfFriends,
    this.numberOfFollowers,
    this.numberOfPlacesVisited,
    this.numberOfFavorites,
    this.numberOfReviews,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    numberOfPosts: json["numberOfPosts"],
    numberOfFriends: json["numberOfFriends"],
    numberOfFollowers: json["numberOfFollowers"],
    numberOfPlacesVisited: json["numberOfPlacesVisited"],
    numberOfFavorites: json["numberOfFavorites"],
    numberOfReviews: json["numberOfReviews"],
  );

  Map<String, dynamic> toJson() => {
    "numberOfPosts": numberOfPosts,
    "numberOfFriends": numberOfFriends,
    "numberOfFollowers": numberOfFollowers,
    "numberOfPlacesVisited": numberOfPlacesVisited,
    "numberOfFavorites": numberOfFavorites,
    "numberOfReviews": numberOfReviews,
  };
}
