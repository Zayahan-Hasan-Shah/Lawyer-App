import 'dart:convert';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';

class LawyerModel extends LawyerEntity {
  LawyerModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.category,
    required super.phone,
    required super.email,
    required super.biography,
    required super.description,
    required super.rating,
    required super.reviews,
    required super.profilePhoto,
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      id: json['id'] as int? ?? 0,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      category: json['category'] as String? ?? json['expertise'] as String? ?? "Criminal",
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      biography: json['biography'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
      profilePhoto: json['profilePhoto'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Category': category,
      'Phone': phone,
      'Email': email,
      'Biography': biography,
      'Rating': rating,
      'Reviews': reviews,
      'ProfilePhoto': profilePhoto,
    };
  }

  static List<LawyerModel> listFromJson(String body) {
    final Map<String, dynamic> parsed = json.decode(body);
    final List<dynamic> items = parsed['data']['items'];
    return items
        .map((e) => LawyerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
