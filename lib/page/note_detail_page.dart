// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_with_sql/db/sql.dart';

// import '../db/notes_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;
  final Color color;

  const NoteDetailPage({
    Key? key,
    required this.note,
    required this.color,
  }) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    note = widget.note;
  }

  // Future refreshNote() async {
  //   setState(() => isLoading = true);

  //   // note = await SQL.readNote(widget.noteId);

  //   setState(() => isLoading = false);
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: widget.color,
        appBar: AppBar(
          backgroundColor: widget.color,
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.description,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await SQL.delete(widget.note);
          Navigator.of(context).pop();
        },
      );
}
