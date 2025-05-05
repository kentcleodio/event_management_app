class Event {
  final int? id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final String? dateCreated;
  final int? userId;
  final String? userName;
  final String? userEmail;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.dateCreated,
    this.userId,
    this.userName,
    this.userEmail,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: int.parse(map['id']),
      title: map['attributes']['title'] as String,
      description: map['attributes']['description'] as String,
      startDate: map['attributes']['start_date'] as String,
      endDate: map['attributes']['end_date'] as String,
      location: map['attributes']['location'] as String,
      dateCreated: map['attributes']['updated_at'] as String,
      userId: int.parse(map['relationship']['user_id']),
      userName: map['relationship']['user_name'] as String,
      userEmail: map['relationship']['user_email'] as String,
    );
  }
}
