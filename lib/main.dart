import 'package:flutter/material.dart';
import 'package:mod3_kel9/screens/login.dart';
import 'package:mod3_kel9/screens/profile.dart';
import 'package:mod3_kel9/screens/splash.dart';
import 'screens/detail.dart';
import 'screens/home.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DetailPage(item: args['item'], title: args['title']);
        },
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}