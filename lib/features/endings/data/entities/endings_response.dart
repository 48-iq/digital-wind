class EndingsResponse {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  EndingsResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory EndingsResponse.fromJson(Map<String, dynamic> json) {
    return EndingsResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}