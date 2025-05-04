import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/controller/authcontroller.dart';
import 'package:notes_app_with_sql/controller/notecontroller.dart';
import 'package:notes_app_with_sql/db/sql.dart';
import 'package:notes_app_with_sql/page/login.dart';
import 'package:notes_app_with_sql/page/notes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize the database connection
  await SQL.connection();
  
  // Pre-initialize controllers to prevent initialization during build
  Get.put(SignupController());
  Get.put(NoteController());
  Get.put(AuthController());
  
  // Check for existing user session
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  
  runApp(MainApp(isLoggedIn: userId != null));
}

class MainApp extends StatelessWidget {
  static String title = 'Notes SQLite';
  final bool isLoggedIn;

  const MainApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    // Close database when app is terminated
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () async {
          await SQL.close();
        },
      ),
    );
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: isLoggedIn ? const NotesPage() : const LoginPage(),
    );
  }
}

// Lifecycle event handler to close database when app is terminated
class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? detachedCallBack;

  LifecycleEventHandler({
    this.detachedCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      await detachedCallBack?.call();
    }
  }
}
