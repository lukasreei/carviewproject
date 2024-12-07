import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    if (_displayNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos os campos são obrigatórios.')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('usuarios').doc(user.uid).set({
          'displayName': _displayNameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrado com sucesso!')),
        );
        return;
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Este email já está em uso.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'A senha é muito fraca.';
      } else {
        errorMessage = 'Erro ao registrar. Tente novamente.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print('Erro ao registrar o usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/registerimage.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _displayNameController,
                decoration: const InputDecoration(labelText: 'NOME',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-MAIL',
                    labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20,),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'SENHA',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                style: TextStyle(color: Colors.white),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => registerUser(context),
                child: const Text('Registrar', style: TextStyle(fontSize: 26),),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  backgroundColor: Colors.grey,
                  minimumSize: Size(160, 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }
}
