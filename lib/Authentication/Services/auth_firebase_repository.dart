import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebaseRepository {
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

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      // Aquí es donde se maneja la creación o búsqueda del perfil
      print("············!!!!!!······${userCredential.user!.uid}");
      print(
        "#######################33${await PerfilCRUD.instance.buscarSiExistePerfil(user!.uid)}",
      );
      if (await PerfilCRUD.instance.buscarSiExistePerfil(user!.uid)) {
        await PerfilCRUD.instance.findPerfil(user!.uid);
      } else {
        PerfilCRUD.instance.recibirUID(user!.uid);
        List<String> nombre = user.displayName!.split(" ");
        DateTime t = DateTime.now();
        Perfil? p = PerfilCRUD.instance.crearPerfilGoogle(
          user.photoURL,
          nombre[0],
          nombre[1],
          user.email,
          t,
        );
        await PerfilCRUD.instance.addPerfil(p);
        await PerfilCRUD.instance.findPerfil(p!.uID!);
      }

      // Devuelve el usuario solo después de que se haya creado o encontrado el perfil
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
