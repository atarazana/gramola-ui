import 'package:gramola_ui/model/check.dart';

class Status {
  final String status;
  final List<Check> checks;
  const Status(
      {required this.status,
       required this.checks});

  factory Status.fromJson(dynamic json) {
    //final parsed = json[''].cast<Map<String, dynamic>>();
    final parsed = json['checks'] as List;
    return Status(status: json['status'] as String, checks: parsed.map<Check>((json) => Check.fromJson(json)).toList());
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'checks': checks,
      };
}
