import 'dart:convert';

class LawyerModel {
  final int id;
  final String firstName;
  final String lastName;
  final String category;
  final String phone;
  final String email;
  final String biography;
  final String description;
  final double rating;
  final int reviews;
  final String profilePhoto;

  LawyerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.category,
    required this.phone,
    required this.email,
    required this.biography,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.profilePhoto,
  });

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      category: json['category'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      biography: json['biography'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      profilePhoto: json['profilePhoto'] as String,
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
