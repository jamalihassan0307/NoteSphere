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
import 'package:notes_app_with_sql/page/splash_screen.dart';
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
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static String title = 'NoteMinder';

  const MainApp({super.key});

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
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.blue.shade700,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.blue.shade800),
          titleTextStyle: TextStyle(
            color: Colors.blue.shade800,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade700,
          secondary: Colors.blue.shade400,
          surface: Colors.white,
          background: Colors.blue.shade50,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
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
