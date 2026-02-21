class ResearchModel {
  final String id;
  final String title;
  final String description;
  final String startDate;
  final String status;
  final String supervisor;

  ResearchModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.status,
    required this.supervisor,
  });

  factory ResearchModel.fromJson(Map<String, dynamic> json) {
    return ResearchModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      status: json['status'] as String,
      supervisor: json['supervisor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'status': status,
      'supervisor': supervisor,
    };
  }
}

class AllResearchResponse {
  final List<ResearchModel> currentResearch;
  final List<ResearchModel> availableResearch;

  AllResearchResponse({
    required this.currentResearch,
    required this.availableResearch,
  });
}
