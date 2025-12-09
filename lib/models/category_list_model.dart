import 'dart:convert';

class CategoryListModel {
  final int code;
  final bool success;
  final String message;
  final List<CategoryModel> data;

  CategoryListModel({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(
      code: json['code'] ?? 0,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CategoryModel>.from(
          json['data'].map((x) => CategoryModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'success': success,
    'message': message,
    'data': data.map((x) => x.toJson()).toList(),
  };
}

class CategoryModel {
  final String category;
  final String displayName;
  final String icon;
  final String group;
  final String? description;

  CategoryModel({
    required this.category,
    required this.displayName,
    required this.icon,
    required this.group,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'] ?? '',
      displayName: json['displayName'] ?? '',
      icon: json['icon'] ?? '',
      group: json['group'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'displayName': displayName,
    'icon': icon,
    'group': group,
    'description': description,
  };
}

// Helper method to parse JSON string directly
CategoryListModel categoryResponseFromJson(String str) =>
    CategoryListModel.fromJson(json.decode(str));

String categoryResponseToJson(CategoryListModel data) =>
    json.encode(data.toJson());
