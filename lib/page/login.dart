// ignore_for_file: avoid_print, unused_local_variable, unused_field

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/page/notes_page.dart';
import 'package:notes_app_with_sql/page/signup.dart';
import 'package:notes_app_with_sql/controller/authcontroller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
    // Move controller clearing to the next frame to avoid build errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthController.to.emailController.clear();
      AuthController.to.passwordController.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Obx(() => Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // App logo
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.note_alt_outlined,
                            color: Colors.blue.shade700,
                            size: size.width * 0.15,
                          ),
                        ),
                      ).animate().scale(duration: const Duration(milliseconds: 600)),
                      
                      const SizedBox(height: 40),
                      // Welcome text
                      Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Welcome Back!',
                              textStyle: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                          displayFullTextOnTap: true,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 200),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            FadeAnimatedText(
                              'Please sign in to continue',
                              textStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.blue.shade600,
                              ),
                              duration: const Duration(milliseconds: 2000),
                            ),
                            FadeAnimatedText(
                              'Your notes are waiting for you',
                              textStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.blue.shade600,
                              ),
                              duration: const Duration(milliseconds: 2000),
                            ),
                          ],
                          repeatForever: true,
                          pause: const Duration(milliseconds: 1000),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 400),
                      ),
                      const SizedBox(height: 40),
                      
                      // Email field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: AuthController.to.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: GoogleFonts.poppins(color: Colors.blue.shade600),
                              prefixIcon: Icon(Icons.email, color: Colors.blue.shade600),
                              border: InputBorder.none,
                              errorStyle: GoogleFonts.poppins(color: Colors.red),
                            ),
                            style: GoogleFonts.poppins(),
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
                        ),
                      ).animate().slideX(
                        duration: const Duration(milliseconds: 500),
                        begin: -1,
                        end: 0,
                        curve: Curves.easeOutQuad,
                        delay: const Duration(milliseconds: 500),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: AuthController.to.passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(color: Colors.blue.shade600),
                              prefixIcon: Icon(Icons.lock, color: Colors.blue.shade600),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.blue.shade400,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              errorStyle: GoogleFonts.poppins(color: Colors.red),
                            ),
                            style: GoogleFonts.poppins(),
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
                        ),
                      ).animate().slideX(
                        duration: const Duration(milliseconds: 500),
                        begin: 1,
                        end: 0,
                        curve: Curves.easeOutQuad,
                        delay: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.poppins(
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 700),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
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
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.blue.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: AuthController.to.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : AnimatedTextKit(
                                  animatedTexts: [
                                    WavyAnimatedText(
                                      'Sign In',
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      speed: const Duration(milliseconds: 200),
                                    ),
                                  ],
                                  isRepeatingAnimation: false,
                                  onTap: AuthController.to.isLoading.value
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
                                ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 800),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Register option
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.poppins(
                                color: Colors.blue.shade700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to registration page
                                Get.to(() => const SignUpPage());
                              },
                              child: Text(
                                'Register',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 900),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
