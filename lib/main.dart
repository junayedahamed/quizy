import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizy/firebase_options.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/admin/admin_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzy',
      theme: AppTheme.theme,
      home: AdminHomeScreen(),
    );
  }
}
