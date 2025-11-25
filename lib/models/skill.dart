class Skill {
  final String id;
  final String name;
  final int proficiency; // 0-100
  final String category;

  Skill({
    required this.id,
    required this.name,
    required this.proficiency,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'proficiency': proficiency,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      proficiency: json['proficiency'] ?? 0,
      category: json['category'] ?? 'Other',
    );
  }

  Skill copyWith({
    String? id,
    String? name,
    int? proficiency,
    String? category,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      proficiency: proficiency ?? this.proficiency,
      category: category ?? this.category,
    );
  }
}
