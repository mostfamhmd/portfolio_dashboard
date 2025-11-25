class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String projectUrl;
  final String githubUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isFeatured;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    this.projectUrl = '',
    this.githubUrl = '',
    this.startDate,
    this.endDate,
    this.isFeatured = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'technologies': technologies,
      'projectUrl': projectUrl,
      'githubUrl': githubUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isFeatured': isFeatured,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      projectUrl: json['projectUrl'] ?? '',
      githubUrl: json['githubUrl'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? technologies,
    String? projectUrl,
    String? githubUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isFeatured,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      technologies: technologies ?? this.technologies,
      projectUrl: projectUrl ?? this.projectUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
