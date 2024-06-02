import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/model/note.dart';
// import 'package:flutter/material.dart';

class SQL {
  static var database = "notes";
  static var ip = "192.168.100.7";
  static final connectToSqlServerDirectlyPlugin = ConnectToSqlServerDirectly();
 static Future connection()  async{
  try {
     return await connectToSqlServerDirectlyPlugin.initializeConnection(
      ip,
      database,
      'ali',   
      '12345',
      instance: 'node',
    ); 
  } catch (e) {
    print("sadfhudsf$e");
  }
  return null;
  
  }
   

  static Future<void> post(String query)  {
    print("query: $query");
    return connectToSqlServerDirectlyPlugin.getStatusOfQueryResult(query);
  }

  static Future<dynamic> get(String query)  async {
    print("query: $query");
    // await connection();
    return await connectToSqlServerDirectlyPlugin.getRowsOfQueryResult(query);
  }

  // static Future<dynamic> Update(String query)  {
  //   print("query: $query");
  //   // await connection();
  //  return  connectToSqlServerDirectlyPlugin.getStatusOfQueryResult(query);
  // }


//  static Future<void> _createDB() async {
//     const createTableQuery = '''
// CREATE TABLE dbo.notes (
//   id INT PRIMARY KEY IDENTITY(1,1), 
//   isImportant BIT NOT NULL,
//   number INT NOT NULL,
//   title NVARCHAR(255) NOT NULL,
//   description NVARCHAR(255) NOT NULL,
//   time NVARCHAR(255) NOT NULL
// )
// ''';
//     await post(createTableQuery);
//   }

static  Future create(Note note) async {
  try {
        final query = '''
INSERT INTO dbo.notestable (isImportant, number, title, description, time) 
VALUES (${note.isImportant ? 1 : 0}, ${note.number}, '${note.title}', '${note.description}', '${note.createdTime.millisecondsSinceEpoch}');

''';
SignupController.to. addNotes(note);
  await get(query);
  } catch (e) {
    
  }

   
  }

 static Future<Note> readNote(int id) async {
    final query = '''
SELECT * FROM dbo.notestable WHERE id = $id;
''';
    final result = await get(query);

    if (result.isNotEmpty) {
      return Note.fromJson(result[0]);
    } else {
      throw Exception('ID $id not found');
    }
  }

 static Future readAllNotes() async {
    final query = '''
SELECT * FROM dbo.notestable ORDER BY time ASC;
''';
    final result = await get(query)     .then((value) {
          print("valueeeeeeeeeeeeeeee${value}");  
          List<Map<String, dynamic>> tempResult = value.cast<Map<String, dynamic>>();
          List<Note> recipe = List.generate(tempResult.length, (i) {
            return Note.fromMap(tempResult[i]);
          });
          SignupController.to.addNotesall(recipe);
        });;

    
  }

 static Future update(Note note) async {
    final query = '''
UPDATE dbo.notestable SET
  isImportant = ${note.isImportant ? 1 : 0},
  number = ${note.number},
  title = '${note.title}',
  description = '${note.description}',
  time = '${note.createdTime}'
WHERE id = ${note.id};
''';
    final result = await get(query);
   
  }

static  Future delete(Note node) async {
    final query = '''
DELETE FROM dbo.notestable WHERE id = ${node.id.toString()};
''';
    final result = await get(query);
    SignupController.to.deleteNote(node);
  
  }


}
