import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/controller/notecontroller.dart';
import 'package:notes_app_with_sql/model/note.dart';
import 'package:notes_app_with_sql/model/usermodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQL {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  static Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textNullable = 'TEXT';

    // Create Notes Table
    await db.execute('''
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType,
      ${NoteFields.color} $integerType DEFAULT 0,
      ${NoteFields.tags} $textType DEFAULT '',
      ${NoteFields.priority} $integerType DEFAULT 1,
      ${NoteFields.reminder} $textNullable,
      ${NoteFields.images} $textNullable
    )
    ''');

    // Create Users Table
    await db.execute('''
    CREATE TABLE users (
      id TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      name TEXT,
      bio TEXT,
      avatar TEXT,
      created_at TEXT,
      updated_at TEXT
    )
    ''');
  }

  static Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns to the notes table
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN ${NoteFields.color} INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN ${NoteFields.tags} TEXT DEFAULT ""');
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN ${NoteFields.priority} INTEGER DEFAULT 1');
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN ${NoteFields.reminder} TEXT');
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN ${NoteFields.images} TEXT');
      
      // Add new columns to the users table
      await db.execute('ALTER TABLE users ADD COLUMN name TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN bio TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN avatar TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN created_at TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN updated_at TEXT');
    }
  }

  static Future<void> connection() async {
    // Initialize the database
    await database;
    
    // Initialize controllers if they're not already registered
    if (!Get.isRegistered<NoteController>()) {
      Get.put(NoteController());
    }
  }

  // Note CRUD Operations
  static Future<Note> create(Note note) async {
    final db = await database;
    final id = await db.insert(tableNotes, note.toJson());
    final createdNote = note.copy(id: id);
    
    // Only update the controller if it's registered
    if (Get.isRegistered<NoteController>()) {
      NoteController.to.addNote(createdNote);
    }
    
    return createdNote;
  }

  static Future<Note> readNote(int id) async {
    final db = await database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static Future<void> readAllNotes() async {
    final db = await database;
    final result = await db.query(
      tableNotes,
      orderBy: '${NoteFields.time} ASC',
    );

    List<Note> notes = result.map((json) => Note.fromJson(json)).toList();
    
    // Update the note controller if it's registered
    if (Get.isRegistered<NoteController>()) {
      NoteController.to.clearNotes();
      NoteController.to.addAllNotes(notes);
    }
  }

  static Future<void> update(Note note) async {
    final db = await database;
    await db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
    
    // Update the note controller if it's registered
    if (Get.isRegistered<NoteController>()) {
      NoteController.to.updateNote(note);
    }
  }

  static Future<void> delete(Note note) async {
    final db = await database;
    await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
    
    // Update the note controller if it's registered
    if (Get.isRegistered<NoteController>()) {
      NoteController.to.deleteNote(note);
    }
  }

  // User CRUD Operations
  static Future<void> createUser(UserModel user) async {
    final db = await database;
    await db.insert('users', {
      'id': user.id,
      'email': user.email,
      'password': user.password,
      'name': user.name,
      'bio': user.bio,
      'avatar': user.avatar,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  static Future<UserModel?> getUserById(String id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  static Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      {
        'email': user.email,
        'name': user.name,
        'bio': user.bio,
        'avatar': user.avatar,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // SQL Query examples for educational purposes
  static Future<void> selectJoinType(String queryType) async {
    final db = await database;
    String query = '';

    switch (queryType) {
      case 'WHERE':
        query = '''
          SELECT * FROM $tableNotes
          WHERE ${NoteFields.number} >= 3
        ''';
        break;

      case 'LIMIT':
        query = '''
          SELECT * FROM $tableNotes
          ORDER BY ${NoteFields.time} DESC
          LIMIT 10
        ''';
        break;

      case 'ORDER BY':
        query = '''
          SELECT * FROM $tableNotes
          ORDER BY ${NoteFields.number} DESC
        ''';
        break;

      case 'GROUP BY':
        query = '''
          SELECT ${NoteFields.title}, COUNT(*) AS note_count 
          FROM $tableNotes
          GROUP BY ${NoteFields.title}
        ''';
        break;

      case 'HAVING':
        query = '''
          SELECT ${NoteFields.title}, COUNT(*) AS note_count
          FROM $tableNotes
          GROUP BY ${NoteFields.title}
          HAVING COUNT(*) > 5
        ''';
        break;

      case 'ALL':
      default:
        query = '''
          SELECT * FROM $tableNotes
        ''';
    }

    try {
      final result = await db.rawQuery(query);
      if (queryType == "GROUP BY" || queryType == "HAVING") {
        Fluttertoast.showToast(
          msg: "Query executed: $queryType\nResult: ${result.length} records found",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16,
          timeInSecForIosWeb: 5,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        List<Note> notes = result.map((json) => Note.fromJson(json)).toList();
        
        // Update the note controller if it's registered
        if (Get.isRegistered<NoteController>()) {
          NoteController.to.clearNotes();
          NoteController.to.addAllNotes(notes);
        }
      }
    } catch (e) {
      debugPrint("Error executing query: $e");
    }
  }

  // Close the database
  static Future close() async {
    final db = await database;
    db.close();
  }
}
