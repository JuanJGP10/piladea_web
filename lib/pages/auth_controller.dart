import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        // Para web: esto ya muestra el popup con selección de cuenta
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _auth.signInWithPopup(googleProvider);
        return userCredential.user;
      } else {
        // Para mobile: forzamos que olvide la cuenta anterior
        final googleSignIn = GoogleSignIn(scopes: ['email']);

        await googleSignIn.disconnect(); // Muy importante
        await googleSignIn.signOut(); // Limpia aún más por si acaso

        // Esto mostrará el selector de cuentas de Google
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect(); // Muy importante también aquí
        await googleSignIn.signOut();
      }
      await _auth.signOut();
      print('Sesión cerrada completamente');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}

final authController = AuthController();
