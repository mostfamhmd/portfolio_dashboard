class Experience {
  final String id;
  final String title;
  final String organization;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final String type; // 'work' or 'education'
  final String location;

  Experience({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.type,
    this.location = '',
  });

  bool get isCurrent => endDate == null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'organization': organization,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'type': type,
      'location': location,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      organization: json['organization'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      type: json['type'] ?? 'work',
      location: json['location'] ?? '',
    );
  }

  Experience copyWith({
    String? id,
    String? title,
    String? organization,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? location,
  }) {
    return Experience(
      id: id ?? this.id,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      location: location ?? this.location,
    );
  }
}
