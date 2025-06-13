import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piladea_web/Model/perfil.dart';

class PerfilCRUD {
  PerfilCRUD._();

  static final PerfilCRUD instance = PerfilCRUD._();

  final CollectionReference perfiles = FirebaseFirestore.instance.collection(
    'Perfiles',
  );

  static String? uid;

  /// CREATE
  Future<void> addPerfil(Perfil? perfil) async {
    if (perfil == null || perfil.uID == null) {
      return;
    }

    perfil.fechaCreacion = DateTime.now();

    await perfiles.add(perfil.toJSON());
  }

  /// READ
  Future<Perfil?> findPerfil(String uID) async {
    var querySnapshot = await perfiles.where("uID", isEqualTo: uID).get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = Map<String, dynamic>.from(querySnapshot.docs[0].data() as Map);

      Timestamp timestamp = data['fechaNacimiento'];
      Timestamp timestamp2 = data['fechaCreacion'];
      DateTime fechaNacimiento = timestamp.toDate();
      DateTime fechaCreacion = timestamp2.toDate();

      Perfil perfil = Perfil.fromJsonWithDate(
        data,
        fechaNacimiento,
        fechaCreacion,
      );
      perfil.docID = querySnapshot.docs[0].id;

      return perfil;
    } else {
      return null;
    }
  }

  /// UPDATE
  Future<void> updatePerfil(String? docID, Perfil? nuevoPerfil) {
    if (docID == null || nuevoPerfil == null) return Future.value();

    return perfiles.doc(docID).update(nuevoPerfil.toJSON());
  }

  // void updateBicicoins(int? bicicoins) {
  //   final result = (currentProfile?.bicicoins ?? 0) - bicicoins!;
  //   currentProfile?.bicicoins = result;
  //   updatePerfil(currentProfile?.docID, currentProfile);
  // }

  /// DELETE
  Future<void> deletePerfil(String docID) {
    return perfiles.doc(docID).delete();
  }

  // /// AGREGAR DATOS RELACIONADOS
  // void anyadirCupon(String id) {
  //   currentProfile?.cupones.add('/Cupones/$id');
  //   updatePerfil(currentProfile?.docID, currentProfile);
  // }

  // void anyadirTrayectos(String id) {
  //   currentProfile?.trayectos.add('/Trayectos/$id');
  //   updatePerfil(currentProfile?.docID, currentProfile);
  // }

  // void anyadirDestino(String id) {
  //   currentProfile?.destinos.add('/Destinos/$id');
  //   updatePerfil(currentProfile?.docID, currentProfile);
  // }

  // /// STREAMING Y CONSULTAS
  // Query<Object?> findPerfilCorreo(String correo) {
  //   return perfiles.where("correo", isEqualTo: correo);
  // }

  // Stream<QuerySnapshot> getPerfilesStream() {
  //   return perfiles.orderBy('fechaNacimiento', descending: true).snapshots();
  // }

  Future<List<Perfil>> getAllPerfiles() async {
    List<Perfil> list = [];

    QuerySnapshot querySnapshotCupon = await perfiles.get();

    for (var document in querySnapshotCupon.docs) {
      var data = Map<String, dynamic>.from(document.data() as Map);
      Timestamp timestamp = data['fechaCreacion'];
      DateTime fechaCreacion = timestamp.toDate();
      Timestamp timestamp2 = data['fechaNacimiento'];
      DateTime fechaNacimiento = timestamp2.toDate();
      list.add(Perfil.fromJsonWithDate(data, fechaNacimiento, fechaCreacion));
    }

    return list;
  }

  /// CREAR PERFILES
  Perfil? crearPerfil(
    String image,
    String nombre,
    String apellido,
    String correo,
    String? sexo,
    DateTime fecha,
  ) {
    if (uid == null) {
      print('❌ UID no recibido antes de crear perfil');
      return null;
    }

    return Perfil(
      admin: false,
      nombre: nombre,
      apellidos: apellido,
      correo: correo,
      sexo: sexo,
      fechaNacimiento: fecha,
      uID: uid,
      rutaImagen: image,
      fechaCreacion: DateTime.now(),
    );
  }

  Perfil? crearPerfilGoogle(
    String? image,
    String? nombre,
    String? apellido,
    String? correo,
    DateTime fechanacimiento,
  ) {
    if (uid == null) {
      print('❌ UID no recibido antes de crear perfil Google');
      return null;
    }

    return Perfil(
      admin: false,
      nombre: nombre,
      apellidos: apellido,
      correo: correo,
      uID: uid,
      rutaImagen: image,
      fechaNacimiento: fechanacimiento,
      fechaCreacion: DateTime.now(),
    );
  }

  /// UID SETTER
  void recibirUID(String? uids) {
    uid = uids;
    print('✅ UID recibido: $uid');
  }

  /// UTILIDADES
  Future<bool> buscarSiExistePerfil(String uD) async {
    List<Perfil> perfiles = await getAllPerfiles();
    return perfiles.any((perfil) => perfil.uID == uD);
  }

  // Future<List<Perfil>> obtenerPerfilesPorFecha(
  //   DateTime fechaInicio,
  //   DateTime fechaFin,
  // ) async {
  //   List<Perfil> list = [];

  //   QuerySnapshot querySnapshotCupon = await perfiles
  //       .where('fechaCreacion', isGreaterThanOrEqualTo: fechaInicio)
  //       .get();

  //   for (var document in querySnapshotCupon.docs) {
  //     var data = Map<String, dynamic>.from(document.data() as Map);
  //     DateTime fechaCreacion = (data['fechaCreacion'] as Timestamp).toDate();
  //     if (fechaCreacion.isBefore(fechaFin) ||
  //         fechaCreacion.isAtSameMomentAs(fechaFin)) {
  //       DateTime fechaNacimiento = (data['fechaNacimiento'] as Timestamp)
  //           .toDate();
  //       list.add(Perfil.fromJsonWithDate(data, fechaNacimiento, fechaCreacion));
  //     }
  //   }

  //   return list;
  // }
}
