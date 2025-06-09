import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebaseRepository {
  bool kIsWeb = true;

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredendial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredendial.user;
      //Se llama a funcion crear Perfil
      PerfilCRUD.instance.recibirUID(user?.uid);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredendial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredendial.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Perfil?> signInWithGoogle() async {
    Perfil? perfilGoogle;
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // 🔹 FLUJO PARA WEB
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        userCredential = await FirebaseAuth.instance.signInWithPopup(
          googleProvider,
        );
      } else {
        // 🔹 FLUJO PARA MÓVIL
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return null; // Usuario canceló

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      User? user = userCredential.user;

      if (user == null) {
        print(user);
        return null;
      }

      print("············!!!!!!······${user.uid}");
      print(
        "#######################33${await PerfilCRUD.instance.buscarSiExistePerfil(user.uid)}",
      );

      if (await PerfilCRUD.instance.buscarSiExistePerfil(user.uid)) {
        perfilGoogle = await PerfilCRUD.instance.findPerfil(user.uid);
      } else {
        PerfilCRUD.instance.recibirUID(user.uid);
        List<String> nombre =
            user.displayName?.split(" ") ?? ["Nombre", "Apellido"];
        DateTime t = DateTime.now();
        Perfil? p = PerfilCRUD.instance.crearPerfilGoogle(
          user.photoURL,
          nombre[0],
          nombre.length > 1 ? nombre[1] : '',
          user.email,
          t,
        );
        perfilGoogle = p;
        await PerfilCRUD.instance.addPerfil(p);
        await PerfilCRUD.instance.findPerfil(p!.uID!);
      }

      return perfilGoogle;
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      return null;
    }
  }
}
