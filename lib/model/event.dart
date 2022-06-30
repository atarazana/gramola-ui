class Event {
  final int id;
  final String name;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String location;
  final String artist;
  final String description;
  final String image;

  const Event(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.startTime,
      required this.endDate,
      required this.endTime,
      required this.location,
      required this.artist,
      required this.description,
      required this.image});

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        startDate = json['startDate'],
        startTime = json['startTime'],
        endDate = json['endDate'],
        endTime = json['endTime'],
        location = json['location'],
        artist = json['artist'],
        description = json['description'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startDate': startDate,
        'startTime': startTime,
        'endDate': endDate,
        'endTime': endTime,
        'location': location,
        'artist': artist,
        'description': description,
        'image': image,
      };
}
