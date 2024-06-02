import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/db/sql.dart';
// import '../db/notes_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';
import '../page/note_detail_page.dart';
import '../widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  

  @override
  void initState() {
    super.initState();
Get.put(SignupController());
    refreshNotes();
  }

  @override
  void dispose() {
  

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() =>SignupController.to. isLoading = true);

    await SQL.readAllNotes();

    setState(() => SignupController.to. isLoading = false);
  }

  @override
  Widget build(BuildContext context) => GetBuilder<SignupController>(
    builder: (obj) {
      return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Notes',
                style: TextStyle(fontSize: 24),
              ),
              actions:  [  PopupMenuButton<String>(
  color: Colors.white,
  onSelected: (String result) {
    SQL.selectJoinType(result);  
  },
  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
                value: 'WHERE',
                child: Text('WHERE (number > 3)'),
              ),
    const PopupMenuItem<String>(
                value: 'ALL',
                child: Text('ALL'),
              ),
              const PopupMenuItem<String>(
                value: 'LIMIT',
                child: Text('LIMIT (Top 10 records)'),
              ),
              const PopupMenuItem<String>(
                value: 'ORDER BY',
                child: Text('ORDER BY (number descending)'),
              ),
              const PopupMenuItem<String>(
                value: 'GROUP BY',
                child: Text('GROUP BY (title)'),
              ),
              const PopupMenuItem<String>(
                value: 'HAVING',
                child: Text('HAVING (count > 5)'),
              ),
  ],
), SizedBox(width: 12)],
            ),
            body: Center(
              child:obj. isLoading
                  ? const CircularProgressIndicator()
                  : obj.notes.isEmpty
                      ? const Text(
                          'No Notes',
                          style: TextStyle(color: Colors.black, fontSize: 24),
                        )
                      : buildNotes(obj),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddEditNotePage()),
                );
      
                // refreshNotes();
              },
            ),
          );
    }
  );
  Widget buildNotes(SignupController obj) => StaggeredGrid.count(
      // itemCount: notes.length,
      // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
       obj. notes.length,
        (index) {
          Note note = obj.notes[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(note: note,color: lightColors[index % lightColors.length],),
                ));

                // refreshNotes();
              },
              child: NoteCardWidget(note: note, index: index),
            ),
          );
        },
      ));

  // Widget buildNotes() => StaggeredGridView.countBuilder(
  //       padding: const EdgeInsets.all(8),
  //       itemCount: notes.length,
  //       staggeredTileBuilder: (index) => StaggeredTile.fit(2),
  //       crossAxisCount: 4,
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       itemBuilder: (context, index) {
  //         final note = notes[index];

  //         return GestureDetector(
  //           onTap: () async {
  //             await Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => NoteDetailPage(noteId: note.id!),
  //             ));

  //             refreshNotes();
  //           },
  //           child: NoteCardWidget(note: note, index: index),
  //         );
  //       },
  //     );
}
