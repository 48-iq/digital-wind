class AllEndingRequest{
  final String id;

  AllEndingRequest(this.id);

  Map<String, dynamic> toJson() => {
      "id": id
  };
}