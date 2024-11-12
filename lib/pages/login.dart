import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carviewproject/pages/authentication/google.dart';
import 'homepage.dart';

class LoginPage extends StatelessWidget {
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
      backgroundColor: Colors.black87,),
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final user = await _googleAuthService.signInWithGoogle();
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
                foregroundColor: Colors.black87, backgroundColor: Colors.amberAccent,
                minimumSize: Size(160, 60),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, size: 24, color: Colors.black87,),
                  SizedBox(width: 12,),
                  Text('Login com Google',
                      style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(160, 60)
              ),
            child: Text('Register', style: TextStyle(fontSize: 24),),)
          ],
        ),
      ),
    );
  }
}
