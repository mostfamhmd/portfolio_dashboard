class SocialLink {
  final String id;
  final String platform;
  final String url;
  final String iconName;

  SocialLink({
    required this.id,
    required this.platform,
    required this.url,
    required this.iconName,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'platform': platform, 'url': url, 'iconName': iconName};
  }

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['id'] ?? '',
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      iconName: json['iconName'] ?? 'link',
    );
  }

  SocialLink copyWith({
    String? id,
    String? platform,
    String? url,
    String? iconName,
  }) {
    return SocialLink(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      url: url ?? this.url,
      iconName: iconName ?? this.iconName,
    );
  }
}
