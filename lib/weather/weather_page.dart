// Importa el paquete de widgets de Material Design para Flutter, que proporciona componentes UI como Scaffold, Text, etc.
import 'package:flutter/material.dart';
// Importa el widget WeatherView, que es la vista principal de la aplicación de clima.
import 'weather_view.dart';

// Define la clase WeatherPage como un widget sin estado (StatelessWidget), que no cambia su estructura una vez construido.
class WeatherPage extends StatelessWidget {
  // Constructor de la clase WeatherPage que acepta una clave super opcional para identificar el widget en el árbol de widgets.
  const WeatherPage({super.key});

  // Sobrescribe el método build, que es el punto de entrada para construir la UI de este widget.
  @override
  Widget build(BuildContext context) {
    // Retorna un Scaffold constante, que es el contenedor base para una página en Material Design.
    // El cuerpo del Scaffold es el widget WeatherView, que maneja toda la lógica de visualización del clima.
    return const Scaffold(body: WeatherView());
  }
}