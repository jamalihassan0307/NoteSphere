final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json[NoteFields.id] as int?,
    isImportant: json[NoteFields.isImportant] == 1,
    number: json[NoteFields.number] as int,
    title: json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
    createdTime: DateTime.parse(json[NoteFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.isImportant: isImportant ? 1 : 0,
    NoteFields.number: number,
    NoteFields.description: description,
    NoteFields.time: createdTime.toIso8601String(),
  };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isImportant': isImportant,
      'number': number,
      'title': title,
      'description': description,
      'createdTime': createdTime.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      isImportant: map['isImportant'] == 1,
      number: map['number'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      createdTime: map['time'] is String 
          ? DateTime.parse(map['time'] as String) 
          : DateTime.fromMillisecondsSinceEpoch(int.parse(map['time'].toString())),
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, isImportant: $isImportant, number: $number, title: $title, description: $description, createdTime: $createdTime)';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.isImportant == isImportant &&
      other.number == number &&
      other.title == title &&
      other.description == description &&
      other.createdTime == createdTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      isImportant.hashCode ^
      number.hashCode ^
      title.hashCode ^
      description.hashCode ^
      createdTime.hashCode;
  }
}
