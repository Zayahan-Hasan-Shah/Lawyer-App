class LawyerEntity {
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

  LawyerEntity({
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

  String get fullName => '$firstName $lastName';
}

class PaginatedLawyersEntity {
  final List<LawyerEntity> lawyers;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  PaginatedLawyersEntity({
    required this.lawyers,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}
