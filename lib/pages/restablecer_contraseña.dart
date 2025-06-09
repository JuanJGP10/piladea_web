import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  void _showSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.black87,
      ),
    );
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Por favor, ingresa tu correo electrónico.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar('Correo de restablecimiento enviado.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('No se encontró un usuario con ese correo.');
      } else if (e.code == 'invalid-email') {
        _showSnackBar('El correo electrónico no es válido.');
      } else {
        _showSnackBar('Error: ${e.message}');
      }
    } catch (e) {
      _showSnackBar('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer contraseña'),
        backgroundColor: const Color(0xFF74d4ff),
      ),
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Introduce tu correo electrónico\ny te enviaremos un enlace para restablecer tu contraseña.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Campo de texto más corto y centrado
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 24),

              // Botón del mismo ancho
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: _sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF74d4ff),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text(
                    'Enviar correo',
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
