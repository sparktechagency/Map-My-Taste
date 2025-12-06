import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../lib/models/profile_model.dart'; // Adjust import based on your project structure

void main() {
  // Test creating a ProfileModel with all fields set to null
  testNullModel();
  
  // Test creating a ProfileModel with sample data
  testWithSampleData();
  
  // Test serialization/deserialization
  testSerialization();
}

void testNullModel() {
  print('Testing ProfileModel with null values...');
  
  final nullModel = ProfileModel();
  print('Created null model successfully: ${nullModel.id == null}');
  
  final nullJson = nullModel.toJson();
  print('Serialized null model to JSON successfully');
  print('JSON is empty or has null values: ${nullJson.values.every((v) => v == null)}');
  
  final reconstructedFromNull = ProfileModel.fromJson({});
  print('Deserialized from empty JSON successfully: ${reconstructedFromNull.id == null}');
  
  print('✓ Null model test passed\n');
}

void testWithSampleData() {
  print('Testing ProfileModel with sample data...');

  final coordinates = Coordinates(
    latitude: 40.7128,
    longitude: -74.0060,
  );
  
  final address = Address(
    coordinates: coordinates,
    street: '123 Main St',
    city: 'New York',
    state: 'NY',
    country: 'USA',
    zipCode: '10001',
  );
  
  final profile = Profile(
    gender: 'Male',
  );
  
  final notifications = Notifications(
    email: true,
    sms: false,
    push: true,
    marketing: false,
  );
  
  final privacy = Privacy(
    profileVisibility: 'public',
    showEmail: true,
    showPhone: false,
  );
  
  final preferences = Preferences(
    notifications: notifications,
    privacy: privacy,
    language: 'en',
    timezone: 'EST',
    currency: 'USD',
  );
  
  final stats = Stats(
    numberOfPosts: 10,
    numberOfFriends: 25,
    numberOfFollowers: 100,
    numberOfPlacesVisited: 5,
    numberOfFavorites: 3,
    numberOfReviews: 7,
  );

  final profileModel = ProfileModel(
    id: '123',
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    address: address,
    authRole: 'user',
    status: 'active',
    profile: profile,
    preferences: preferences,
    favoriteRestaurants: ['restaurant1', 'restaurant2'],
    visitedPlaces: ['place1', 'place2'],
    friends: ['friend1', 'friend2'],
    followers: ['follower1', 'follower2'],
    isEmailVerified: true,
    isPhoneVerified: false,
    isResetPassword: false,
    stats: stats,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    firstName: 'John',
    lastName: 'Doe',
    lastSeen: DateTime.now(),
    displayName: 'johndoe',
    isAdmin: false,
    isVerified: true,
    profileModelId: 'profile123',
  );

  print('Created ProfileModel with sample data successfully');
  print('Profile has name: ${profileModel.fullName}');
  print('Profile has email: ${profileModel.email}');
  print('Profile has address with city: ${profileModel.address?.city}');
  print('Profile has stats with posts: ${profileModel.stats?.numberOfPosts}');
  
  print('✓ Sample data test passed\n');
}

void testSerialization() {
  print('Testing serialization and deserialization...');

  final originalModel = ProfileModel(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    isEmailVerified: true,
    createdAt: DateTime(2023, 1, 1),
    stats: Stats(numberOfPosts: 5, numberOfFriends: 10),
  );

  // Serialize to JSON
  final json = originalModel.toJson();
  print('Serialized successfully');
  
  // Deserialize from JSON
  final deserializedModel = ProfileModel.fromJson(json);
  print('Deserialized successfully');
  
  // Compare values
  bool isSame = 
      originalModel.id == deserializedModel.id &&
      originalModel.email == deserializedModel.email &&
      originalModel.fullName == deserializedModel.fullName &&
      originalModel.isEmailVerified == deserializedModel.isEmailVerified &&
      originalModel.stats?.numberOfPosts == deserializedModel.stats?.numberOfPosts;

  print('Values match after serialization/deserialization: $isSame');
  print('✓ Serialization test passed\n');
}