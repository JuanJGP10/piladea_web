import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Pages/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:piladea_web/pages/auth_controller.dart';

class LoginView extends StatefulWidget {
  static String id = 'login_view';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController txtEmail;
  late TextEditingController txtPassword;
  bool _isLoading = false; // Por si quieres mostrar progreso

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
      print("-------------------${userCredential.user!.uid}");
      await PerfilCRUD.instance.findPerfil(userCredential.user!.uid);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Aquí puedes mostrar un error específico si quieres
      }
    }
    return null;
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
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Colors.purpleAccent,
              ),
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log in',
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.purpleAccent,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 85),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.05,
              ),
              child: SizedBox(
                height: 60,
                width: 600,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: const InputDecoration(
                    labelText: 'email',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  controller: txtEmail,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.1,
                right: size.width * 0.1,
                bottom: size.height * 0.05,
              ),
              child: SizedBox(
                height: 60,
                width: 600,
                child: TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'contraseña',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                  controller: txtPassword,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() => _isLoading = true);
                      UserCredential? credenciales = await login(
                        txtEmail.text,
                        txtPassword.text,
                      );
                      setState(() => _isLoading = false);

                      if (credenciales != null && credenciales.user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } else {
                        _showSnackBar(
                          'El correo o la contraseña son incorrectos',
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            const SizedBox(height: 15),
            const Text(
              'o continúa con ',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            const SizedBox(height: 30),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.google,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () async {
                final user = await authController.loginWithGoogle();

                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al iniciar sesión con Google'),
                    ),
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
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'signup_view');
                  },
                  child: const Text(
                    'Registrate ahora',
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
