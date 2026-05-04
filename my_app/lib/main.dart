import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/camera_service.dart';
import 'theme/app_theme.dart'; 

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/profile/screens/profile_screen.dart';
import 'screens/profile/providers/profile_provider.dart';
import 'screens/profile/providers/tags_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- INIT SERVICES ---
  await CameraService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => TagsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hatid',

      // ← swap the old green theme for the hatid theme
      theme: AppTheme.light,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}