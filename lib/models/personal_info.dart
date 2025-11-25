class PersonalInfo {
  final String name;
  final String title;
  final String bio;
  final String photoUrl;
  final String email;
  final String phone;
  final String location;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.bio,
    required this.photoUrl,
    required this.email,
    required this.phone,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'bio': bio,
      'photoUrl': photoUrl,
      'email': email,
      'phone': phone,
      'location': location,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      bio: json['bio'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
    );
  }

  PersonalInfo copyWith({
    String? name,
    String? title,
    String? bio,
    String? photoUrl,
    String? email,
    String? phone,
    String? location,
  }) {
    return PersonalInfo(
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
    );
  }

  static PersonalInfo get empty => PersonalInfo(
    name: '',
    title: '',
    bio: '',
    photoUrl: '',
    email: '',
    phone: '',
    location: '',
  );
}
