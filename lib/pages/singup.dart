import 'package:flutter/material.dart';
class SignupView extends StatelessWidget{
  static String id='signup_view';
  const SignupView({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: const Center(
        child: Text(
          'Pantalla de registro',
          style: TextStyle(color:Colors.white,fontSize: 24),

        ),
      ),
    );
  }
}