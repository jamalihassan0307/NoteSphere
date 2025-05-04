// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/model/note.dart';


class SignupController extends GetxController {
  static SignupController get to => Get.find();
  RxString email = ''.obs;
  RxString pass = ''.obs;
  RxInt currentIndex = 0.obs;
  final List<Note> notes=[];
  bool isLoading = false;
  // UserCredential? userCredential;
  bool isVerified = false;
  addNotes(Note model){
    notes.add(model);
    update();
  }
  updatenote(Note model){

  
    notes[  notes.indexWhere((element) => element.id==model.id)]=model;
    update();
  }
  deleteNote(Note model){
    notes.removeWhere((element) => element.id==model.id);
    update();
  }
  addNotesall(List<Note> model){
    notes.addAll(model);
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

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  void updatePage(int newIndex) {
    currentIndex.value = newIndex;
    update();
  }

  void updateEmailPass(String inputEmail, String inputPass) {
    email.value = inputEmail;
    pass.value = inputPass;
  }

  void updateProgress(int pageNumber, bool status) {
    progress[pageNumber].value = status;
    update();
  }

  void clearProgress() {
    email = ''.obs;
    pass = ''.obs;
    progress = [true.obs, false.obs, false.obs];
  }

  void verifyAccountUpdate(bool inputStatus) async {
    isVerified = inputStatus;
    update(); // Simulate verification success
  }
}
