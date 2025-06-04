import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Pages/home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatelessWidget {
  static String id = 'login_view';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtEmail = TextEditingController();
    TextEditingController txtPassword = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          //centramos automáticamente
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    blurRadius: 30.0,
                    color: Colors.purpleAccent,
                    offset: Offset(0, 0), // glow centrado
                  ),
                  Shadow(
                    blurRadius: 60.0,
                    color: Colors.purpleAccent,
                    offset: Offset(0, 0), // glow centrado
                  ),
                ],
              ),
            ),
            SizedBox(height: 85),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.05,
              ),
              //email
              child: SizedBox(
                height: 60,
                width: 600, // altura que quieras
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: const InputDecoration(
                    labelText: 'email',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  controller: txtEmail,
                  onChanged: (value) {},
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
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'contraseña',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                  onChanged: (value) {},
                  controller: txtPassword,
                ),
              ),
            ),
            //botón
            ElevatedButton(
              onPressed: () async {
                UserCredential? credenciales = await login(
                  txtEmail.text,
                  txtPassword.text,
                );
                if (credenciales != null) {
                  if (credenciales.user != null) {
                    //direccionamiento hacia la pagina de home
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      'El correo o la contraseña son incorrectos ',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 0.0,
                                right: 0.0,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentSnackBar();
                                },
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15), //espacio entre el botón y el texto

            const Text(
              'o continúa con ',
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            SizedBox(height: 30),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.google,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () async {
                final url = Uri.parse('https://mail.google.com/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudo abrir Gmail.')),
                  );
                }
              },
            ),
            SizedBox(height: 50),
            const Text(
              '¿No eres miembro? ',
              style: TextStyle(color: Colors.white, fontSize: 17.0),
            ),
            const Text(
              'Registrate ahora',
              style: TextStyle(color: Colors.purpleAccent, fontSize: 17.0),
            ),

            //logo de google
          ],
        ),
      ),
    );
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
        //Implementar error
      }
    }
    return null;
  }
}
