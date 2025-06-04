import 'package:piladea_web/Controller/perfil_CRUD.dart';
import 'package:piladea_web/Authentication/structures/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<PerfilCRUD>(() => PerfilCRUD());
  }
}
