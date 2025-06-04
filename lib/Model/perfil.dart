import 'package:piladea_web/Controller/fechaActual.dart';

// import 'package:piladea_webapp/Controller/perfil_CRUD.dart';
// import 'cupon.dart';

class Perfil {
  //Atributos

  String? uID;

  String? docID;

  String? nombre;

  String? apellidos;

  DateTime? fechaNacimiento;

  String? correo;

  String? sexo;

  String? rutaImagen;

  List<dynamic> cupones = [];

  List<dynamic> destinos = [];

  List<dynamic> trayectos = [];

  bool admin = false;

  int? bicicoins = 0;

  final DateTime fechaCreacion;

  //Constructores
  Perfil({
    this.nombre,
    this.apellidos,
    this.fechaNacimiento,
    this.sexo,
    this.correo,
    this.uID,
    this.rutaImagen,
    required this.admin,
  }) : fechaCreacion = fechaActual().obtenerFechaActual();

  Perfil.fromJson(Map<String, dynamic> json)
    : nombre = json['nombre'],
      apellidos = json['apellidos'],
      fechaNacimiento = DateTime.parse(json['fechaNacimiento']),
      correo = json['correo'],
      sexo = json['sexo'],
      uID = json['uID'],
      rutaImagen = json['rutaImagen'],
      bicicoins = json['bicicoins'],
      destinos = json['destinos'],
      cupones = json['cupones'],
      trayectos = json['trayectos'],
      admin = json['admin'],
      fechaCreacion = DateTime.parse(json['fechaCreacion']);

  Perfil.fromJsonWithDate(
    Map<String, dynamic> json,
    DateTime dateTime,
    DateTime datetime2,
  ) : nombre = json['nombre'],
      apellidos = json['apellidos'],
      fechaNacimiento = dateTime,
      correo = json['correo'],
      sexo = json['sexo'],
      uID = json['uID'],
      rutaImagen = json['rutaImagen'],
      bicicoins = json['bicicoins'],
      destinos = json['destinos'],
      cupones = json['cupones'],
      trayectos = json['trayectos'],
      admin = json['admin'],
      fechaCreacion = datetime2;

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> listado = {
      'nombre': nombre,
      'apellidos': apellidos,
      'fechaNacimiento': fechaNacimiento,
      'sexo': sexo,
      'correo': correo,
      'uID': uID,
      'rutaImagen': rutaImagen,
      'bicicoins': bicicoins,
      'cupones': cupones,
      'destinos': destinos,
      'trayectos': trayectos,
      'admin': admin,
      'fechaCreacion': fechaCreacion,
    };
    return listado;
  }

  Map<String, dynamic> toJSONGSheet() {
    Map<String, dynamic> listado = {
      'nombre': nombre,
      'apellidos': apellidos,
      'fechaNacimiento': fechaNacimiento.toString(),
      'sexo': sexo,
      'correo': correo,
      'uID': uID,
      'rutaImagen': rutaImagen,
      'bicicoins': bicicoins,
      'cupones': cupones.length,
      'destinos': destinos.length,
      'trayectos': trayectos.length,
      'admin': admin,
      'fechaCreacion': fechaCreacion.toString(),
    };
    return listado;
  }

  // void updateBicicoinsResta(int bicicoins) {
  //   this.bicicoins = this.bicicoins! - bicicoins;
  //   PerfilCRUD.instance.updatePerfil(docID, this);
  // }

  // void updateBicicoinsSuma(int bicicoins) {
  //   this.bicicoins = this.bicicoins! + bicicoins;
  //   PerfilCRUD.instance.updatePerfil(docID, this);
  // }

  static List<String> getFields() => [
    'docID',
    'fechaCreacion',
    'cupones',
    'destinos',
    'nombre',
    'apellidos',
    'admin',
    'bicicoins',
    'correo',
    'fechaNacimiento',
    'rutaImagen',
    'sexo',
    'trayectos',
    'uID',
  ];
}
