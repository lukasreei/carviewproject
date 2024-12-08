import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carviewproject/pages/authentication/google.dart';
import 'package:carviewproject/pages/authentication/email.dart';
import 'package:carviewproject/pages/home/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carviewproject/pages/authentication/register.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
            ),
          ),
          const Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Text(
              'CARS STORE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmailLoginPage(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final user = await GoogleAuthService().signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Homepage(analytics: FirebaseAnalytics.instance),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Falha ao fazer login, tente novamente.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.grey,
                    minimumSize: Size(160, 60),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.login, size: 24, color: Colors.black87),
                      SizedBox(width: 12),
                      Text(
                        'Login com Google',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(160, 60),
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
