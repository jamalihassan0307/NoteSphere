import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_with_sql/db/sql.dart';
// import '../db/notes_database.dart';
import '../model/note.dart';
import '../widget/note_form_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  late int selectedColor;
  late String tagsString;
  late int priorityLevel;
  String? reminderDate;
  String? imagesPaths;
  final ImagePicker _picker = ImagePicker();
  List<File> imageFiles = [];
  DateTime? selectedDateTime;

  final List<int> colorOptions = [
    0xFFE57373, // Red 300
    0xFF64B5F6, // Blue 300
    0xFFFFD54F, // Amber 300
    0xFF81C784, // Green 300
    0xFFBA68C8, // Purple 300
    0xFF4FC3F7, // Light Blue 300
    0xFF4DB6AC, // Teal 300
    0xFFFFB74D, // Orange 300
  ];

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    selectedColor = widget.note?.color ?? 0;
    tagsString = widget.note?.tags ?? '';
    priorityLevel = widget.note?.priority ?? 1;
    reminderDate = widget.note?.reminder;
    imagesPaths = widget.note?.images;
    
    if (imagesPaths != null && imagesPaths!.isNotEmpty) {
      imagesPaths!.split(',').forEach((path) {
        if (path.isNotEmpty) {
          imageFiles.add(File(path));
        }
      });
    }

    if (reminderDate != null) {
      selectedDateTime = DateTime.parse(reminderDate!);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFiles.add(File(image.path));
        imagesPaths = imageFiles.map((file) => file.path).join(',');
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      imageFiles.removeAt(index);
      imagesPaths = imageFiles.map((file) => file.path).join(',');
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
      );
      
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          reminderDate = selectedDateTime!.toIso8601String();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              widget.note == null ? 'Create Note' : 'Edit Note',
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
        ),
        backgroundColor: Color(selectedColor),
        elevation: 0,
        actions: [buildButton()],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(selectedColor).withOpacity(0.7),
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColorPicker(),
                const SizedBox(height: 16),
                Text(
                  'Title',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  initialValue: title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (title) => title != null && title.isEmpty 
                      ? 'The title cannot be empty' 
                      : null,
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  initialValue: description,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Note description...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  maxLines: 5,
                  validator: (value) => value != null && value.isEmpty
                      ? 'The description cannot be empty'
                      : null,
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority Level',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          DropdownButtonFormField<int>(
                            value: priorityLevel,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_downward, color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text('Low', style: GoogleFonts.poppins()),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    const Icon(Icons.remove, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text('Medium', style: GoogleFonts.poppins()),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_upward, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text('High', style: GoogleFonts.poppins()),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                priorityLevel = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important?',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Center(
                              child: Switch(
                                value: isImportant,
                                activeColor: Colors.redAccent,
                                onChanged: (bool value) {
                                  setState(() {
                                    isImportant = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tags (comma separated)',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  initialValue: tagsString,
                  decoration: InputDecoration(
                    hintText: 'e.g. work, personal, urgent',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    prefixIcon: const Icon(Icons.tag),
                  ),
                  onChanged: (value) => tagsString = value,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set Reminder',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                            onTap: () => _selectDateTime(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time),
                                  const SizedBox(width: 8),
                                  Text(
                                    selectedDateTime != null
                                        ? DateFormat('MMM dd, yyyy hh:mm a').format(selectedDateTime!)
                                        : 'No reminder set',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (selectedDateTime != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            selectedDateTime = null;
                            reminderDate = null;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Images',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                if (imageFiles.isNotEmpty)
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageFiles.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(imageFiles[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 13,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text('Add Image', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(selectedColor),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Number',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Slider(
                  value: number.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: number.toString(),
                  activeColor: Color(selectedColor),
                  onChanged: (value) {
                    setState(() {
                      number = value.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colorOptions.length,
            itemBuilder: (context, index) {
              final color = colorOptions[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == color ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      if (selectedColor == color)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                  child: selectedColor == color
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null,
                ).animate().scale(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      delay: Duration(milliseconds: index * 50),
                    ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? Colors.green : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: isFormValid ? addOrUpdateNote : null,
        icon: const FaIcon(FontAwesomeIcons.floppyDisk, size: 18),
        label: Text(
          'Save',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      color: selectedColor,
      tags: tagsString,
      priority: priorityLevel,
      reminder: reminderDate,
      images: imagesPaths,
    );

    await SQL.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now(),
      color: selectedColor,
      tags: tagsString,
      priority: priorityLevel,
      reminder: reminderDate,
      images: imagesPaths,
    );

    await SQL.create(note);
  }
}
