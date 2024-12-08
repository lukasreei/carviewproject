import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:carviewproject/pages/home/homepage.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginWithEmailAndPassword(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha o e-mail e a senha.')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(analytics: FirebaseAnalytics.instance),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Usuário não encontrado.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta.';
      } else {
        errorMessage = 'Erro ao fazer login. Tente novamente.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                )
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _loginWithEmailAndPassword(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.grey,
              fixedSize: Size(270, 60)
            ),
            child: const Text(
              'Login com E-mail',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
