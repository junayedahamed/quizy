import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizy/firebase_options.dart';
import 'package:quizy/src/theme/theme.dart';
import 'package:quizy/src/view/login_register/auth_page_providers/register_providers/register_providers.dart';
import 'package:quizy/src/view/login_register/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(providers: AppProviders.providers, child: const MyApp()),
  );
  // MultiBlocProvider(providers: AppProviders.providers, child: const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzy',
      theme: AppTheme.theme,

      // home: AdminHomeScreen(),
      home: LoginPage(),
    );
  }
}
