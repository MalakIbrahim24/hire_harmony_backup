class Service {
  final String id;
  final String name;
  final String description;
  final String image;

  Service(
      {required this.id,
      required this.name,
      required this.description,
      required this.image});

  factory Service.fromMap(Map<String, dynamic> data, String documentId) {
    return Service(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}
