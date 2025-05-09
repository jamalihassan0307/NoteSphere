// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/model/note.dart';


class SignupController extends GetxController {
  static SignupController get to => Get.find();
  
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  
  PageController pageController = PageController(initialPage: 0);
  
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString pass = ''.obs;
  RxBool isLoading = false.obs;
  
  // Using RxList to properly track list changes
  RxList<Note> notes = <Note>[].obs;
  
  // Current user information
  String? currentUserId;
  
  RxInt currentIndex = 0.obs;
  
  void updatePage(int index) {
    currentIndex.value = index;
    // Trigger update to ensure UI reflects the change
    update();
  }
  
  void clearProgress() {
    pageController = PageController(initialPage: 0);
    currentIndex.value = 0;
    // Clear notes when changing major state
    clearNotes();
    update();
  }
  
  // Clear notes list before adding new ones
  void clearNotes() {
    notes.clear();
    update();
  }
  
  void addNotesall(List<Note> noteData) {
    // Clear existing notes before adding all new ones
    notes.clear();
    notes.addAll(noteData);
    update();
  }
  
  void addNotes(Note note) {
    notes.add(note);
    update();
  }
  
  void updatenote(Note note) {
    final index = notes.indexWhere((element) => element.id == note.id);
    if (index >= 0) {
      notes[index] = note;
      update();
    }
  }
  
  void deleteNote(Note note) {
    notes.removeWhere((element) => element.id == note.id);
    update();
  }
  
  // Set current user ID when user logs in
  void setCurrentUser(String userId) {
    currentUserId = userId;
    // Clear notes when changing user
    clearNotes();
    update();
  }

  List<RxBool> progress = [
    true.obs,
    false.obs,
    false.obs,
  ];

  @override
  void onInit() {
    // Initialize email and pass
    email = ''.obs;
    pass = ''.obs;
    super.onInit();
  }
  
  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void updateEmailPass(String inputEmail, String inputPass) {
    email.value = inputEmail;
    pass.value = inputPass;
  }

  void updateProgress(int pageNumber, bool status) {
    progress[pageNumber].value = status;
    update();
  }

  void verifyAccountUpdate(bool inputStatus) async {
    // Simulate verification success
  }
}
