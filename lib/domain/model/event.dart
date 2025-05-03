class Event {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final DateTime dateCreated;
  final int userId;
  final String userName;
  final String userEmail;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.dateCreated,
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: map['start_date'] as DateTime,
      endDate: map['end_date'] as DateTime,
      location: map['location'] as String,
      dateCreated: map['date_created'] as DateTime,
      userId: map['user_id'] as int,
      userName: map['user_name'] as String,
      userEmail: map['user_email'] as String,
    );
  }
}
