import 'dart:math';

class ImagenesAleatorias {
  final List<String> _listaImagenes = [
    '/images/ciclista_negro.png',
    '/images/ciclista_amarillo.png',
    '/images/ciclista_azul.png',
  ];

  static final int _siguienteNumero = 0;

  var rng = Random();

  String obtenerRutaImagenAleatoria() {
    return _listaImagenes[rng.nextInt(3)];
  }
}
