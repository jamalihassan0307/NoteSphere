import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/controller/authcontroller.dart';
import 'package:notes_app_with_sql/page/login.dart';
import 'package:notes_app_with_sql/page/notes_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  
  File? profileImage;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;
  String errorMessage = '';
  
  final ImagePicker picker = ImagePicker();
  
  @override
  void initState() {
    Get.put(SignupController());
    super.initState();
  }
  
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
          print("Image selected successfully: ${pickedFile.path}");
        });
        
        // Show confirmation to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Image selected successfully',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error selecting image: ${e.toString()}',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blue.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Profile Picture',
                style: GoogleFonts.poppins(
                  color: Colors.blue.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera Option
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.camera);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.blue.shade700,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Camera',
                        style: GoogleFonts.poppins(
                          color: Colors.blue.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Gallery Option
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.gallery);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.photo_library_rounded,
                            color: Colors.blue.shade700,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Gallery',
                        style: GoogleFonts.poppins(
                          color: Colors.blue.shade800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> registerUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    try {
      // final id = DateTime.now().millisecondsSinceEpoch.toString();
      String? imagePath;
      
      // Check if we have a profile image
      if (profileImage != null) {
        imagePath = profileImage!.path;
        print("Saving user with image path: $imagePath");
      }
      
      // Use AuthController to register user
      final success = await AuthController.to.register(
        emailController.text,
        passwordController.text,
        nameController.text,
      );
      
      if (success) {
        // Navigate to notes page
        Get.offAll(() => const NotesPage());
      } else {
        setState(() {
          errorMessage = 'Failed to create account. Please try again.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      print("Registration error: $e");
    }
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.blue.shade800,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ).animate().slideX(
                          duration: const Duration(milliseconds: 400),
                          begin: -1,
                          end: 0,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Animated Title
                      Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Create Account',
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
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Subtitle
                      Center(
                        child: Text(
                          'Sign up to start your journey',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 400),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Profile Image Selector
                      Center(
                        child: GestureDetector(
                          onTap: showImagePickerOptions,
                          child: AvatarGlow(
                            endRadius: 70,
                            glowColor: Colors.blue.shade200,
                            duration: const Duration(milliseconds: 1500),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue.shade300,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade100,
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                                image: profileImage != null
                                    ? DecorationImage(
                                        image: FileImage(profileImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: profileImage == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.blue.shade400,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Error Message
                      if (errorMessage.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  errorMessage,
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().shake(),
                      
                      // Form Fields
                      // Name Field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: GoogleFonts.poppins(color: Colors.blue.shade600),
                              prefixIcon: Icon(Icons.person, color: Colors.blue.shade600),
                              border: InputBorder.none,
                              errorStyle: GoogleFonts.poppins(color: Colors.red),
                            ),
                            style: GoogleFonts.poppins(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
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
                      
                      const SizedBox(height: 16),
                      
                      // Email Field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: emailController,
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
                        begin: 1,
                        end: 0,
                        curve: Curves.easeOutQuad,
                        delay: const Duration(milliseconds: 600),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Password Field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: GoogleFonts.poppins(color: Colors.blue.shade600),
                              prefixIcon: Icon(Icons.lock, color: Colors.blue.shade600),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.blue.shade400,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              errorStyle: GoogleFonts.poppins(color: Colors.red),
                            ),
                            style: GoogleFonts.poppins(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
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
                        begin: -1,
                        end: 0,
                        curve: Curves.easeOutQuad,
                        delay: const Duration(milliseconds: 700),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Confirm Password Field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: confirmPasswordController,
                            obscureText: hideConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: GoogleFonts.poppins(color: Colors.blue.shade600),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.blue.shade600),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hideConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.blue.shade400,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hideConfirmPassword = !hideConfirmPassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              errorStyle: GoogleFonts.poppins(color: Colors.red),
                            ),
                            style: GoogleFonts.poppins(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
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
                        delay: const Duration(milliseconds: 800),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Bio Field
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: TextFormField(
                            controller: bioController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Bio (Optional)',
                              labelStyle: GoogleFonts.poppins(color: Colors.blue.shade600),
                              prefixIcon: Icon(Icons.description, color: Colors.blue.shade600),
                              border: InputBorder.none,
                              alignLabelWithHint: true,
                            ),
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 900),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.blue.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 1000),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Login Option
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: GoogleFonts.poppins(
                                color: Colors.blue.shade700,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.off(() => const LoginPage());
                              },
                              child: Text(
                                'Sign In',
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
                        delay: const Duration(milliseconds: 1100),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
