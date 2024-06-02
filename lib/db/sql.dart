import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  static Future<void> selectJoinType(String queryType) async {
    String query = '';

    switch (queryType) {
      case 'WHERE':
        query = '''
          SELECT * FROM notestable
          WHERE number >=3
        ''';
        break;

      case 'LIMIT':
        query = '''
          SELECT TOP 10 * FROM notestable
          ORDER BY time DESC
        ''';
        break;

      case 'ORDER BY':
        query = '''
          SELECT * FROM notestable
          ORDER BY number DESC
        ''';
        break;

      case 'GROUP BY':
        query = '''
          SELECT title, COUNT(*) AS note_count 
          FROM notestable
          GROUP BY title
        ''';
        break;

      case 'HAVING':
        query = '''
          SELECT title, COUNT(*) AS note_count
          FROM notestable
          GROUP BY title
          HAVING COUNT(*) > 5
        ''';
        break;

      default:
        query = '''
          SELECT * FROM notestable
        ''';
    }

    print("Executing query: $query");

    try {
      await SQL.get(query).then((value) {
        if (queryType == "GROUP BY" || queryType == "HAVING") {
          List<Map<String, dynamic>> tempResult = value.cast<Map<String, dynamic>>();
          List<dynamic> data = tempResult;
              Fluttertoast.showToast(
            msg: "Query executed: $queryType\nResult: ${data.length} records found",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16,
            timeInSecForIosWeb: 5,


 
            toastLength: Toast.LENGTH_LONG,
          );
          
          print("Result: $data");
        } else {
          List<Map<String, dynamic>> tempResult = value.cast<Map<String, dynamic>>();
          List<Note> notes = tempResult.map((e) => Note.fromMap(e)).toList();
          SignupController.to.notes.clear();
          SignupController.to.addNotesall(notes);
          print("Query result: $notes");
        }
      }).catchError((error) {
        print("Error while executing the query: $error");
      });
    } catch (e) {
      print("Exception: $e");
    }
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
    SignupController.to.updatenote(note);
    await get(query);
   
  }

static  Future delete(Note node) async {
    final query = '''
DELETE FROM dbo.notestable WHERE id = ${node.id.toString()};
''';
    final result = await get(query);
    SignupController.to.deleteNote(node);
  
  }


}
