import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/model/usermodel.dart';
import 'package:notes_app_with_sql/db/sql.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/page/notes_page.dart';
import 'package:notes_app_with_sql/page/login.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  RxBool isLoggedIn = false.obs;
  RxBool isLoading = false.obs;

  // Text controllers for login and registration
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // Get current user data
  UserModel? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    
    if (userId != null) {
      // User is logged in, get user data
      final user = await SQL.getUserById(userId);
      if (user != null) {
        _currentUser.value = user;
        isLoggedIn.value = true;
        
        // Update the user ID in signup controller as well
        SignupController.to.setCurrentUser(userId);
        
        // Navigate to notes page if not already there
        if (Get.currentRoute != '/NotesPage') {
          Get.offAll(() => const NotesPage());
        }
      } else {
        // User ID stored but user not found in database
        await logout();
      }
    } else {
      isLoggedIn.value = false;
    }
    isLoading.value = false;
  }

  // Login user
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await SQL.getUser(email, password);
      if (user != null) {
        _currentUser.value = user;
        isLoggedIn.value = true;
        
        // Store user ID in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.id);
        
        // Update the user ID in signup controller
        SignupController.to.setCurrentUser(user.id);
        
        isLoading.value = false;
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
    isLoading.value = false;
    return false;
  }
  
  // Register user
  Future<bool> register(String email, String password, String name) async {
    isLoading.value = true;
    try {
      // Generate a unique ID for the user (you might want to use a UUID package)
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final user = UserModel(
        id: userId,
        email: email,
        password: password,
        name: name,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      
      await SQL.createUser(user);
      _currentUser.value = user;
      isLoggedIn.value = true;
      
      // Store user ID in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.id);
      
      // Update the user ID in signup controller
      SignupController.to.setCurrentUser(user.id);
      
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
    }
    isLoading.value = false;
    return false;
  }
  
  // Update user profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    isLoading.value = true;
    try {
      await SQL.updateUser(updatedUser);
      _currentUser.value = updatedUser;
      isLoading.value = false;
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
    }
    isLoading.value = false;
    return false;
  }
  
  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    
    _currentUser.value = null;
    isLoggedIn.value = false;
    
    // Clear the user ID in signup controller
    SignupController.to.setCurrentUser('');
    
    // Navigate to login page
    Get.offAll(() => const LoginPage());
  }
} 