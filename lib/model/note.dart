final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time, color, tags, priority, reminder, images
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final String color = 'color';
  static final String tags = 'tags';
  static final String priority = 'priority';
  static final String reminder = 'reminder';
  static final String images = 'images';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;
  final int color; // Storing color as integer
  final String tags; // Comma-separated tags
  final int priority; // 1-Low, 2-Medium, 3-High
  final String? reminder; // ISO date string for reminder
  final String? images; // Comma-separated paths

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.color,
    required this.tags,
    required this.priority,
    this.reminder,
    this.images,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
    int? color,
    String? tags,
    int? priority,
    String? reminder,
    String? images,
  }) =>
      Note(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        color: color ?? this.color,
        tags: tags ?? this.tags,
        priority: priority ?? this.priority,
        reminder: reminder ?? this.reminder,
        images: images ?? this.images,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
        color: json[NoteFields.color] as int? ?? 0,
        tags: json[NoteFields.tags] as String? ?? '',
        priority: json[NoteFields.priority] as int? ?? 1,
        reminder: json[NoteFields.reminder] as String?,
        images: json[NoteFields.images] as String?,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.number: number,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
        NoteFields.color: color,
        NoteFields.tags: tags,
        NoteFields.priority: priority,
        NoteFields.reminder: reminder,
        NoteFields.images: images,
      };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isImportant': isImportant,
      'number': number,
      'title': title,
      'description': description,
      'createdTime': createdTime.millisecondsSinceEpoch,
      'color': color,
      'tags': tags,
      'priority': priority,
      'reminder': reminder,
      'images': images,
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
      color: map['color'] as int? ?? 0,
      tags: map['tags'] as String? ?? '',
      priority: map['priority'] as int? ?? 1,
      reminder: map['reminder'] as String?,
      images: map['images'] as String?,
    );
  }

  List<String> getTagsList() {
    return tags.isNotEmpty ? tags.split(',') : [];
  }

  @override
  String toString() {
    return 'Note(id: $id, isImportant: $isImportant, number: $number, title: $title, description: $description, createdTime: $createdTime, color: $color, tags: $tags, priority: $priority, reminder: $reminder, images: $images)';
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
      other.createdTime == createdTime &&
      other.color == color &&
      other.tags == tags &&
      other.priority == priority &&
      other.reminder == reminder &&
      other.images == images;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      isImportant.hashCode ^
      number.hashCode ^
      title.hashCode ^
      description.hashCode ^
      createdTime.hashCode ^
      color.hashCode ^
      tags.hashCode ^
      priority.hashCode ^
      reminder.hashCode ^
      images.hashCode;
  }
}
