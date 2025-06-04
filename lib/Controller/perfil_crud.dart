import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:get/get.dart';

class PerfilCRUD {
  static PerfilCRUD get instance => Get.put(PerfilCRUD());
  //obtener la colección de perfiles
  final CollectionReference perfiles = FirebaseFirestore.instance.collection(
    'Perfiles',
  );

  //CREATE: añadir nuevos perfiles
  static String? uid;
  static Perfil? currentProfile;
  Future<void> addPerfil(Perfil? perfil) {
    return perfiles.add(perfil?.toJSON());
  }

  //READ: obtener los perfiles de la base de datos

  Future<Perfil?> findPerfil(String uID) async {
    try {
      var querySnapshot = await perfiles.where("uID", isEqualTo: uID).get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = Map<String, dynamic>.from(
          querySnapshot.docs[0].data() as Map,
        );

        Timestamp timestamp = data['fechaNacimiento'];
        Timestamp timestamp2 = data['fechaCreacion'];
        DateTime fechaNacimiento = timestamp.toDate();
        DateTime fechaCreacion = timestamp2.toDate();

        Perfil perfil = Perfil.fromJsonWithDate(
          data,
          fechaNacimiento,
          fechaCreacion,
        );
        print("··································${perfil}");
        perfil.docID = querySnapshot.docs[0].id;
        currentProfile = perfil;

        return perfil;
      } else {
        print("No profile found for uID: $uID");
        return null;
      }
    } catch (e) {
      print("Error completing: $e");
      return null;
    }
  }

  void anyadirCupon(String id) {
    currentProfile?.cupones.add('/Cupones/$id');
    updatePerfil(currentProfile?.docID, currentProfile);
  }

  void anyadirTrayectos(String id) {
    currentProfile?.trayectos.add('/Trayectos/$id');
    updatePerfil(currentProfile?.docID, currentProfile);
  }

  void anyadirDestino(String id) {
    currentProfile?.destinos.add('/Destinos/$id');
    updatePerfil(currentProfile?.docID, currentProfile);
  }

  Query<Object?> findPerfilCorreo(String correo) {
    CollectionReference usuario = FirebaseFirestore.instance.collection(
      'Perfiles',
    );
    return perfiles.where("correo", isEqualTo: correo);
  }

  //READ-ALL: obtener los perfiles de la base de datos

  Stream<QuerySnapshot> getPerfilesStream() {
    final perfilesStream = perfiles
        .orderBy('fechaNacimiento', descending: true)
        .snapshots();
    return perfilesStream;
  }

  Future<List<Perfil>> getAllPerfiles() async {
    List<Perfil> list = [];

    QuerySnapshot querySnapshotCupon = await perfiles.get();

    querySnapshotCupon.docs.forEach((document) {
      var data = Map<String, dynamic>.from(document.data() as Map);
      Timestamp timestamp = data['fechaCreacion'];
      DateTime fechaCreacion = timestamp.toDate();
      Timestamp timestamp2 = data['fechaNacimiento'];
      DateTime fechaNacimiento = timestamp2.toDate();
      list.add(Perfil.fromJsonWithDate(data, fechaNacimiento, fechaCreacion));
    });

    return list;
  }

  //UPDATE: actualizar perfiles por doc ID

  Future<void> updatePerfil(String? docID, Perfil? nuevoPerfil) {
    currentProfile = nuevoPerfil;
    currentProfile?.docID = docID;
    return perfiles.doc(docID).update(nuevoPerfil!.toJSON());
  }

  void updateBicicoins(int? bicicoins) {
    final result = (currentProfile?.bicicoins ?? 0) - bicicoins!;
    currentProfile?.bicicoins = result;
    PerfilCRUD.instance.updatePerfil(currentProfile?.docID, currentProfile);
  }
  //DELETE: eliminar perfil de la base de datos por doc ID

  Future<void> deletePerfil(String docID) {
    return perfiles.doc(docID).delete();
  }

  Perfil? crearPerfil(
    String image,
    String nombre,
    String apellido,
    String correo,
    String? sexo,
    DateTime fecha,
  ) {
    Perfil p = Perfil(
      admin: false,
      nombre: nombre,
      apellidos: apellido,
      correo: correo,
      sexo: sexo,
      fechaNacimiento: fecha,
      uID: uid,
      rutaImagen: image,
    );

    return p;
  }

  void recibirUID(String? uids) {
    uid = uids;
  }

  Perfil? crearPerfilGoogle(
    String? image,
    String? nombre,
    String? apellido,
    String? correo,
    DateTime fechanacimiento,
  ) {
    Perfil p = Perfil(
      admin: false,
      nombre: nombre,
      apellidos: apellido,
      correo: correo,
      uID: uid,
      rutaImagen: image,
      fechaNacimiento: fechanacimiento,
    );
    return p;
  }

  //FUNCIONES

  Future<bool> buscarSiExistePerfil(String uD) async {
    List<Perfil> perfiles = await getAllPerfiles();
    bool encontrado = false;
    perfiles.forEach((perfil) {
      if (perfil.uID == uD) {
        encontrado = true;
      }
    });
    return encontrado;
  }

  //FUNCIONES PARA ESTADISTICAS

  Future<List<Perfil>> obtenerPerfilesPorFecha(
    DateTime fechaInicio,
    DateTime fechaFin,
  ) async {
    List<Perfil> list = [];

    QuerySnapshot querySnapshotCupon = await perfiles
        .where('fechaCreacion', isGreaterThanOrEqualTo: fechaInicio)
        .get();

    querySnapshotCupon.docs.forEach((document) {
      var data = Map<String, dynamic>.from(document.data() as Map);
      Timestamp timestamp = data['fechaCreacion'];
      DateTime fechaCreacion = timestamp.toDate();
      if (fechaCreacion.compareTo(fechaFin) <= 0) {
        Timestamp timestamp2 = data['fechaNacimiento'];
        DateTime fechaNacimiento = timestamp2.toDate();
        list.add(Perfil.fromJsonWithDate(data, fechaNacimiento, fechaCreacion));
      }
    });

    return list;
  }
}
