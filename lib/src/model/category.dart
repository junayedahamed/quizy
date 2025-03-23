class Category {
  final String id, description, name;
  final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
  });

  factory Category.fromMap(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'] ?? "",
      description: data['description'] ?? "",
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  Category copyWith({String? name, String? description}) {
    return Category(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt,
    );
  }
}
