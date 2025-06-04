import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Authentication/services/auth_firebase_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rxn<User?> firebaseUser = Rxn<User?>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  registerwithEmailAndPassword(String email, String pass) async {
    firebaseUser.value = await AuthFirebaseRepository()
        .registerWithEmailAndPassword(email: email, password: pass);
  }

  /*loginwithEmailAndPassword(String email, String pass) async {
    firebaseUser.value = await AuthFirebaseRepository()
        .loginWithEmailAndPassword(email: email, password: pass);
    print(
        "__________________________________________________________________________");
    PerfilCRUD.instance.findPerfil(firebaseUser.value!.uid);
  }*/

  Future<User?> loginWithGoogle() async {
    return await AuthFirebaseRepository().signInWithGoogle();
  }
}
