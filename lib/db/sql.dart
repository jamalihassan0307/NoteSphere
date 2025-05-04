import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Create Notes Table
    await db.execute('''
    CREATE TABLE $tableNotes (
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType
    )
    ''');

    // Create Users Table
    await db.execute('''
    CREATE TABLE users (
      id $textType,
      email $textType,
      password $textType
    )
    ''');
  }

  static Future<void> connection() async {
    // Initialize the database
    await database;
  }

  // Note CRUD Operations
  static Future<Note> create(Note note) async {
    final db = await database;
    final id = await db.insert(tableNotes, note.toJson());
    final createdNote = note.copy(id: id);
    SignupController.to.addNotes(createdNote);
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
    SignupController.to.addNotesall(notes);
  }

  static Future<void> update(Note note) async {
    final db = await database;
    await db.update(
      tableNotes,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
    SignupController.to.updatenote(note);
  }

  static Future<void> delete(Note note) async {
    final db = await database;
    await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
    SignupController.to.deleteNote(note);
  }

  // User CRUD Operations
  static Future<void> createUser(UserModel user) async {
    final db = await database;
    await db.insert('users', {
      'id': user.id,
      'email': user.email,
      'password': user.password,
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
        SignupController.to.notes.clear();
        SignupController.to.addNotesall(notes);
      }
    } catch (e) {
      print("Error executing query: $e");
    }
  }

  // Close the database
  static Future close() async {
    final db = await database;
    db.close();
  }
}
