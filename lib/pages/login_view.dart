import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';

class LoginView extends StatelessWidget {
  static String id = 'login_view';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController txtEmail = TextEditingController();
    TextEditingController txtPassword = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          //centramos automáticamente
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(color: Colors.purpleAccent, fontSize: 40.0),
            ),
            SizedBox(height: 85),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1,
                vertical: size.height * 0.05,
              ),
              //email
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'email',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onChanged: (value) {},
                controller: txtEmail,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.1,
                right: size.width * 0.1,
                bottom: size.height * 0.05,
              ),

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
