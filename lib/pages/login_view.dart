import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:piladea_web/Pages/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piladea_web/Authentication/structures/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  static String id = 'login_view';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthController authController = Get.put(AuthController());
  late TextEditingController txtEmail;
  late TextEditingController txtPassword;
  bool _isLoading = false;
  bool _isPasswordHidden = true;
  late Perfil perfilLlave;

  @override
  void initState() {
    super.initState();
    txtEmail = TextEditingController();
    txtPassword = TextEditingController();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<UserCredential?> login(String email, String contra) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: contra);

      Perfil? perfilEncontrado = await PerfilCRUD.instance.findPerfil(
        userCredential.user!.uid,
      );

      if (perfilEncontrado == null) {
        throw Exception("No se encontró el perfil del usuario.");
      }

      perfilLlave = perfilEncontrado;
      return userCredential;

    } on FirebaseAuthException catch (e) {
      String mensajeError;

      switch (e.code) {
        case 'user-not-found':
          mensajeError = 'No existe un usuario con ese correo.';
          break;
        case 'wrong-password':
          mensajeError = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          mensajeError = 'Correo inválido.';
          break;
        default:
          mensajeError = 'Error de autenticación: ${e.message}';
      }

      _showSnackBar(mensajeError);
      return null;

    } catch (e) {
      _showSnackBar('Error inesperado: ${e.toString()}');
      return null;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 15)),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Color(0xFF2b7fff)),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 40,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 600,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        controller: txtEmail,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 600,
                      child: TextField(
                        obscureText: _isPasswordHidden,
                        controller: txtPassword,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordHidden = !_isPasswordHidden;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        if (txtEmail.text.trim().isEmpty ||
                            txtPassword.text.isEmpty) {
                          _showSnackBar(
                            'Por favor, ingresa correo y contraseña.',
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        UserCredential? credenciales = await login(
                          txtEmail.text.trim(),
                          txtPassword.text,
                        );
                        setState(() => _isLoading = false);

                        if (credenciales != null &&
                            credenciales.user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(perfil: perfilLlave),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF74d4ff),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.black87,
                      )
                          : const Text(
                        'Log in',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'o continúa con ',
                      style: TextStyle(color: Colors.black87, fontSize: 15.0),
                    ),
                    const SizedBox(height: 30),
                    IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        size: 50,
                        color: Colors.black87,
                      ),
                      onPressed: () async {
                        Perfil? perfilGoogle =
                        await authController.loginWithGoogle();
                        if (perfilGoogle != null) {
                          perfilLlave = perfilGoogle;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(perfil: perfilLlave),
                            ),
                          );
                        } else {
                          _showSnackBar(
                            'Error al iniciar sesión con Google',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No eres miembro? ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'signup_view');
                          },
                          child: const Text(
                            'Regístrate ahora',
                            style: TextStyle(
                              color: Color(0xFF2b7fff),
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
