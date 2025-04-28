class EndingsResponse {
  final String id;

  EndingsResponse({
    required this.id
  });

  factory EndingsResponse.fromJson(Map<String, dynamic> json) {
    return EndingsResponse(
      id: json['id']
    );
  }
}