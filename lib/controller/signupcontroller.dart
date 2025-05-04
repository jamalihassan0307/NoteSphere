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
  
  List<Note> notes = [];
  
  // Current user information
  String? currentUserId;
  
  RxInt currentIndex = 0.obs;
  
  void updatePage(int index) {
    currentIndex.value = index;
  }
  
  void clearProgress() {
    pageController = PageController(initialPage: 0);
    currentIndex.value = 0;
  }
  
  void addNotesall(List<Note> noteData) {
    notes.addAll(noteData);
    update();
  }
  
  void addNotes(Note note) {
    notes.add(note);
    update();
  }
  
  void updatenote(Note note) {
    final index = notes.indexWhere((element) => element.id == note.id);
    notes[index] = note;
    update();
  }
  
  void deleteNote(Note note) {
    notes.removeWhere((element) => element.id == note.id);
    update();
  }
  
  // Set current user ID when user logs in
  void setCurrentUser(String userId) {
    currentUserId = userId;
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
