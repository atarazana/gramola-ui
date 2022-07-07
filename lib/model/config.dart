import 'package:gramola_ui/model/status.dart';

class Config {
  final String name;
  final Status status;
  const Config(
      {required this.name,
       required this.status});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(name: json['name'], status: Status.fromJson(json['status']));
  }
    
  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
      };
}
