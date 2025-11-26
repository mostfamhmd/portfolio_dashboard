class Skill {
  final String id;
  final String name;
  final String category;

  Skill({
    required this.id,
    required this.name,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Other',
    );
  }

  Skill copyWith({
    String? id,
    String? name,
    String? category,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }
}
