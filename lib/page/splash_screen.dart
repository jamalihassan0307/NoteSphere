import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/controller/authcontroller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    
    // Check login status - this will navigate to the appropriate screen
    await AuthController.to.checkLoginStatus();
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.note_alt_outlined,
                  color: Colors.blue.shade700,
                  size: size.width * 0.25,
                ),
              ).animate()
               .scale(
                 duration: const Duration(milliseconds: 800),
                 curve: Curves.elasticOut,
                 delay: const Duration(milliseconds: 300),
               ),
              
              const SizedBox(height: 30),
              
              // App Name
              DefaultTextStyle(
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'NoteMinder',
                      duration: const Duration(milliseconds: 2000),
                      fadeInEnd: 0.3,
                      fadeOutBegin: 0.7,
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Tagline
              Text(
                'Organize Your Thoughts',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.blue.shade600,
                ),
              ).animate()
               .fadeIn(
                 delay: const Duration(milliseconds: 800),
                 duration: const Duration(milliseconds: 500),
               ),
              
              const SizedBox(height: 60),
              
              // Loading indicator
              CircularProgressIndicator(
                color: Colors.blue.shade700,
                strokeWidth: 3,
              ).animate()
               .fadeIn(
                 delay: const Duration(milliseconds: 1000),
                 duration: const Duration(milliseconds: 500),
               ),
            ],
          ),
        ),
      ),
    );
  }
} 