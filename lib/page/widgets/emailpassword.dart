// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/db/sql.dart';
import 'package:notes_app_with_sql/model/usermodel.dart';
import 'package:notes_app_with_sql/page/login.dart';

class EmailPass extends StatefulWidget {
  const EmailPass({super.key});

  @override
  State<EmailPass> createState() => _EmailPassState();
}

class _EmailPassState extends State<EmailPass> {
  GlobalKey<FormState> formKey = GlobalKey();
  SignupController signupController = Get.put(SignupController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _confirmPassFocusNode = FocusNode();

  String? errorTextEmail;
  String? errorTextSubmitPassword;
  String? errorTextPassword;

  bool hidPass = true;
  bool hidConfirmPass = true;
  bool isSigningUp = false;

  Future signUpAccount(String emailAddress, String password) async {
  
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      UserModel model = UserModel(
        password: password,
        id: id,
        email: emailAddress,
      );
      
      // Use the new SQL createUser method
      await SQL.createUser(model);
     
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
  }

  // Validator for password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextPassword = 'Please enter a password';
    }
    if (value.length < 6) {
      return errorTextPassword =
          'Weak Password it should be at least 6 characters';
    } else {
      setState(() {
        return errorTextPassword = null;
      });
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextEmail = 'Please enter an email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return errorTextEmail = 'Please enter a valid email address';
    } else {
      return errorTextEmail = null;
    }
  }

  String? validateSubmitPassword(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextSubmitPassword = 'Please enter a password again';
    }
    if (confirmPassController.text != passController.text) {
      return errorTextSubmitPassword = 'Submitpassword must equal the password';
    }
    if (confirmPassController.text == passController.text) {
      return errorTextSubmitPassword = null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                          color: Colors.grey[850] ?? Colors.transparent,
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
                  cursorColor: Colors.grey[850],
                  cursorRadius: const Radius.circular(25),
                  cursorWidth: 2.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _passFocusNode,
                  obscureText: hidPass,
                  controller: passController,
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
                          color: Colors.grey[850] ?? Colors.transparent,
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
                  cursorColor: Colors.grey[850],
                  cursorRadius: const Radius.circular(25),
                  cursorWidth: 2.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _confirmPassFocusNode,
                  obscureText: hidConfirmPass,
                  controller: confirmPassController,
                  validator: validateSubmitPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_reset_rounded,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidConfirmPass = !hidConfirmPass;
                        });
                      },
                      icon: Icon(
                        hidConfirmPass == true
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),
                    hintText: 'Confirm Password',
                    label: Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.5,
                          color: Colors.grey[850] ?? Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    errorText: errorTextSubmitPassword,
                    errorStyle: TextStyle(
                      color: Colors.red[900],
                      fontSize: 14,
                    ),
                  ),
                  cursorColor: Colors.grey[850],
                  cursorRadius: const Radius.circular(25),
                  cursorWidth: 2.5,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                        signUpAccount(emailController.text, passController.text);
                          _emailFocusNode.unfocus();
                          _passFocusNode.unfocus();
                          _confirmPassFocusNode.unfocus();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: size.width / 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width / 8,
                            height: size.width / 8,
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius:
                                    BorderRadius.circular(size.width / 25)),
                            child: const Icon(
                              color: Colors.white,
                              size: 25,
                              Icons.navigate_next_rounded,
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}
