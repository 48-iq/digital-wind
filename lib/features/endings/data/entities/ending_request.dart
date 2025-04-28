class EndingRequest{
  final String id;

  EndingRequest(this.id);

  Map<String, dynamic> toJson() => {
      "id": id
  };
}