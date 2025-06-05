import 'dart:math';

class ImagenesAleatorias {
  final List<String> _listaImagenes = [
    'assets/images/ciclista_negro.png',
    'assets/images/ciclista_amarillo.png',
    'assets/images/ciclista_azul.png',
  ];

  static final int _siguienteNumero = 0;

  var rng = Random();

  String obtenerRutaImagenAleatoria() {
    return _listaImagenes[rng.nextInt(3)];
  }
}
