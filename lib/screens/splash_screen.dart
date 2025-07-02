import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:laravan_com/core/token_storage.dart';
import 'package:laravan_com/screens/login_screen.dart';
import 'package:laravan_com/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
  await Future.delayed(const Duration(milliseconds: 1000)); 

  final hasAccess = TokenStorage.accessToken != null;
  final hasUser = TokenStorage.currentUser != null;

  if (kDebugMode) {
    print('SplashScreen: accessToken = ${TokenStorage.accessToken}');
    print('SplashScreen: currentUser = ${TokenStorage.currentUser}');
  }

  final target = (hasAccess && hasUser) ? HomeScreen() : LoginScreen();

  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => target),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Branding/logo
            Image.asset(
              'images/laravel-1-logo-png-transparent.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.business, size: 100, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24),
            const Text(
              'Laravan Company',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
