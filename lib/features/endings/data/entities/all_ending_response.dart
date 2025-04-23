class AllEndingResponse{
  final List<String> endings;

  AllEndingResponse({
    required this.endings
  });

  factory AllEndingResponse.fromJson(Map<String, dynamic> json){
    return AllEndingResponse(
      endings: json["endings"],
    );
  }
}