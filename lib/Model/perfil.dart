// import 'package:piladea_webapp/Controller/perfil_CRUD.dart';
// import 'cupon.dart';

class Perfil {
  //Atributos
  bool admin;
  String? nombre;
  String? apellidos;
  String? correo;
  String? sexo;
  DateTime fechaNacimiento;
  DateTime fechaCreacion;
  String? uID;
  String? rutaImagen;
  int bicicoins;
  List<String> cupones;
  List<String> trayectos;
  List<String> destinos;
  String? docID;

  Perfil({
    required this.admin,
    this.nombre,
    this.apellidos,
    this.correo,
    this.sexo,
    required this.fechaNacimiento,
    required this.fechaCreacion, // <-- asegúrate de incluirlo
    this.uID,
    this.rutaImagen,
    this.bicicoins = 0,
    this.cupones = const [],
    this.trayectos = const [],
    this.destinos = const [],
    this.docID,
  });

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
