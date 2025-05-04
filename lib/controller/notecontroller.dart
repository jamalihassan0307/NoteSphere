import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/model/note.dart';
import 'package:notes_app_with_sql/db/sql.dart';

class NoteController extends GetxController {
  static NoteController get to => Get.find();
  
  // Using RxList to properly track list changes
  RxList<Note> notes = <Note>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentFilter = 0.obs; // 0: All, 1: Important, 2: High Priority, etc.
  RxString searchQuery = ''.obs;
  
  // Method to refresh notes from the database
  Future<void> refreshNotes() async {
    isLoading.value = true;
    // Clear existing notes before fetching
    clearNotes();
    await loadAllNotes();
    isLoading.value = false;
  }
  
  // Load all notes from database
  Future<void> loadAllNotes() async {
    try {
      final db = await SQL.database;
      final result = await db.query(
        tableNotes,
        orderBy: '${NoteFields.time} ASC',
      );
      
      List<Note> loadedNotes = result.map((json) => Note.fromJson(json)).toList();
      notes.addAll(loadedNotes);
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
  }
  
  // Clear notes list
  void clearNotes() {
    notes.clear();
    update();
  }
  
  // Add a single note
  void addNote(Note note) {
    notes.add(note);
    update();
  }
  
  // Add multiple notes
  void addAllNotes(List<Note> notesList) {
    notes.addAll(notesList);
    update();
  }
  
  // Update an existing note
  void updateNote(Note note) {
    final index = notes.indexWhere((element) => element.id == note.id);
    if (index >= 0) {
      notes[index] = note;
      update();
    }
  }
  
  // Delete a note
  void deleteNote(Note note) {
    notes.removeWhere((element) => element.id == note.id);
    update();
  }
  
  // Create a new note
  Future<Note> createNote(Note note) async {
    isLoading.value = true;
    final createdNote = await SQL.create(note);
    addNote(createdNote);
    isLoading.value = false;
    return createdNote;
  }
  
  // Update a note in the database
  Future<void> saveNote(Note note) async {
    isLoading.value = true;
    await SQL.update(note);
    updateNote(note);
    isLoading.value = false;
  }
  
  // Delete a note from the database
  Future<void> removeNote(Note note) async {
    isLoading.value = true;
    await SQL.delete(note);
    deleteNote(note);
    isLoading.value = false;
  }
  
  // Get filtered notes based on search and filter criteria
  List<Note> getFilteredNotes() {
    List<Note> filteredNotes = List.from(notes);
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filteredNotes = filteredNotes
          .where((note) =>
              note.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              note.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
              note.tags.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply additional filters
    switch (currentFilter.value) {
      case 1: // Important
        return filteredNotes.where((note) => note.isImportant).toList();
      case 2: // High Priority
        return filteredNotes.where((note) => note.priority == 3).toList();
      case 3: // Medium Priority
        return filteredNotes.where((note) => note.priority == 2).toList();
      case 4: // Low Priority
        return filteredNotes.where((note) => note.priority == 1).toList();
      default: // All
        return filteredNotes;
    }
  }
  
  // Update the current filter
  void setFilter(int filter) {
    currentFilter.value = filter;
    update();
  }
  
  // Update the search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
    update();
  }
  
  // Clear the search query
  void clearSearchQuery() {
    searchQuery.value = '';
    update();
  }
} 