// ignore_for_file: avoid_print, unused_local_variable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/db/sql.dart';
import 'package:notes_app_with_sql/page/notes_page.dart';
import 'package:notes_app_with_sql/page/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:notes_app_with_sql/controller/authcontroller.dart';

// import 'package:notes_app_with_sql/home.dart';
// import 'package:notes_app_with_sql/pages/signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  @override
  void initState() {
    super.initState();
    // Clear the text fields when the page loads
    AuthController.to.emailController.clear();
    AuthController.to.passwordController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  // App logo or image
                  Center(
                    child: Image.asset(
                      'assets/images.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Email field
                  TextFormField(
                    controller: AuthController.to.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password field
                  TextFormField(
                    controller: AuthController.to.passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: AuthController.to.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                // Show loading indicator
                                setState(() {
                                  _isLoading = true;
                                });
                                
                                final email = AuthController.to.emailController.text;
                                final password = AuthController.to.passwordController.text;
                                
                                // Login using AuthController
                                final success = await AuthController.to.login(email, password);
                                
                                if (success) {
                                  // Navigate to notes page
                                  Get.offAll(() => const NotesPage());
                                } else {
                                  // Show error message
                                  Get.snackbar(
                                    'Login Failed',
                                    'Invalid email or password.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                                
                                // Hide loading indicator
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: AuthController.to.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to registration page
                          Get.to(() => const SignUpPage());
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
