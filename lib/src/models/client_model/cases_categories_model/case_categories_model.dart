class CaseCategoriesModel {
  final int id;
  final String category;
  CaseCategoriesModel({required this.id, required this.category});
  factory CaseCategoriesModel.fromJson(Map<String, dynamic> json) {
    return CaseCategoriesModel(id: json['id'], category: json['category']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'category': category};
  }

}

class CaseCategoriesModelList {
  final List<CaseCategoriesModel> categories;
  CaseCategoriesModelList({required this.categories});
}