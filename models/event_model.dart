class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
  });

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
