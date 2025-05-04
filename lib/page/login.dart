// ignore_for_file: avoid_print, unused_local_variable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/db/sql.dart';
import 'package:notes_app_with_sql/page/notes_page.dart';
import 'package:notes_app_with_sql/page/signup.dart';

// import 'package:notes_app_with_sql/home.dart';
// import 'package:notes_app_with_sql/pages/signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool hidPass = true;
  String errorMessage = '';
  String? errorTextEmail;
  String? errorTextPassword;

  bool uploading = false;

  @override
  void initState() {
    super.initState();
  }

  Future signingInWithEmail(String email, String pass) async {
    try {
      final user = await SQL.getUser(email, pass);
      
      if (user != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage()));
      } else {
        Fluttertoast.showToast(
          msg: "User Not Found!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          fontSize: 17,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      print("Error during login: $e");
      Fluttertoast.showToast(
        msg: "Login failed: ${e.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        fontSize: 17,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextEmail = 'Please enter an email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return errorTextEmail = 'Please enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextPassword = 'Please enter Your Name';
    } else {
      return errorTextPassword = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.grey[850],
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: size.width / 2,
                   child: Image(image: AssetImage("assets/images.png",)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: loginFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: validateEmail,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email_rounded,
                                  ),
                                  hintText: 'Email',
                                  label: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Colors.grey[850] ??
                                            Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  errorText: errorTextEmail,
                                  errorStyle: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 14,
                                  ),
                                ),
                                onChanged: (value) {
                                  
                                },
                                cursorColor: Colors.grey[850],
                                cursorRadius: const Radius.circular(25),
                                cursorWidth: 2.5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: hidPass,
                                controller: _passController,
                                validator: validatePassword,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock_rounded,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidPass = !hidPass;
                                      });
                                    },
                                    icon: Icon(
                                      hidPass == true
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                    ),
                                  ),
                                  hintText: 'Password',
                                  label: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Colors.grey[850] ??
                                            Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  errorText: errorTextPassword,
                                  errorStyle: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 14,
                                  ),
                                ),
                                onChanged: (value) {
                                  // if (isChecking != null) {
                                  //   isChecking!.change(false);
                                  // }
                                  // if (isHandsUp == null) return;

                                  // isHandsUp!.change(true);
                                },
                                cursorColor: Colors.grey[850],
                                cursorRadius: const Radius.circular(25),
                                cursorWidth: 2.5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: size.width,
                          height: size.width / 8,
                          child: ElevatedButton(
                            onPressed: () async {
                             
                              if (loginFormKey.currentState!.validate()) {
                                signingInWithEmail(_emailController.text,
                                    _passController.text);
                              }else{
                                 print("sdfh");
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey[850]),
                            ),
                            child: Text(
                              'Sing In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "if you don't have account",
                          style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: size.width,
                          height: size.width / 8,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(const SignUpPage());
                            },
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey[850] ??
                                            Colors.transparent),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size.width,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              color: Colors.white,
                              width: 30,
                              child: Center(
                                child: Text(
                                  'Or',
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in with   ',
                              style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            uploading
                                ? Container(
                                    width: size.width / 6.5,
                                    height: size.width / 6.5,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[400] ??
                                                Colors.transparent,
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ]),
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.green[800]!),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        uploading = true;
                                      });
                                      // signInWithGoogle();
                                    },
                                    child: Container(
                                      width: size.width / 6.5,
                                      height: size.width / 6.5,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[400] ??
                                                  Colors.transparent,
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ]),
                                      child: SvgPicture.asset(
                                        'assets/google-icon-logo-svgrepo-com.svg',
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
