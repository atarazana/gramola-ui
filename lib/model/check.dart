class Check {
  final String name;
  final String status;

  const Check(
      {required this.name,
      required this.status});

  Check.fromJson(dynamic json)
      : name = json['name'] as String,
        status = json['status'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
      };
}
