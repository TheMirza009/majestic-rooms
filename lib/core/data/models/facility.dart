class Facility {
  final int id;
  final String name;
  final String? slug;
  final String? icon;

  const Facility({
    required this.id,
    required this.name,
    this.slug,
    this.icon,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      icon: json['icon'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Facility &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
