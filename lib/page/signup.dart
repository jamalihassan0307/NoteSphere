import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/page/login.dart';
import 'package:notes_app_with_sql/page/widgets/emailpassword.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  // SignupController signupController = Get.find();

  TextEditingController userNameController = TextEditingController();

  String? errorTextUserName;

  bool hidPass = true;
  bool hidConfirmPass = true;

  final ImagePicker picker = ImagePicker();
  File? file;
  String? url;
  // List of pages to display
  List<Widget> pages = [
    const EmailPass(),
    // const Verify(),
  ];
  @override
void initState() {
    Get.put(SignupController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            // await FirebaseAuth.instance.signOut();
            SignupController.to.clearProgress();
             SignupController.to.updatePage(0);
            Get.offAll(const LoginPage());
          },
          icon: Icon(
            color: Colors.grey[850],
            size: 30,
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.grey[850],
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetBuilder<SignupController>(
        builder: (obj) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                 SizedBox(
                    width: size.width / 2,
                   child: Image(image: AssetImage("assets/images.png",)),
                  ),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    SizedBox(
                      height: size.height / 2,
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pages.length,
                        controller: obj.pageController,
                        onPageChanged: (index) {
                          if (index < 1) {
                            index++;
                            obj.updatePage(index);
                          }
                        },
                        itemBuilder: (context, index) {
                          return pages[obj.currentIndex.value];
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
