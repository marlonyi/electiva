// Importa el paquete de Material Design para UI.
import 'package:flutter/material.dart';
// Importa el modelo de clima para usar en la vista.
import '../models/weather_model.dart';
// Importa un helper para diseño responsive (ajusta UI según tamaño de pantalla).
import '../utils/responsive_helper.dart';
// Importa el servicio de clima para interactuar con la API.
import 'weather_service.dart';
// Importa funciones matemáticas para animaciones.
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

// Define WeatherView como un widget con estado (StatefulWidget), que puede cambiar dinámicamente.
class WeatherView extends StatefulWidget {
  // Constructor con clave super opcional.
  const WeatherView({super.key});

  // Crea el estado asociado para este widget.
  @override
  State<WeatherView> createState() => _WeatherViewState();
}

// Clase privada del estado de WeatherView.
class _WeatherViewState extends State<WeatherView> {
  // Instancia del servicio de clima para llamadas a la API.
  final WeatherService _weatherService = WeatherService();
  // Variable nullable para almacenar los datos del clima actual.
  WeatherModel? _weather;
  // Booleano para indicar si se está cargando datos (muestra spinner).
  bool _isLoading = false;
  // Variable nullable para mensajes de error.
  String? _error;
  // Booleano para indicar si la API está conectada (datos reales vs. mock).
  bool _isApiConnected = false;
  // Controlador para el campo de texto de búsqueda de ciudad.
  final TextEditingController _cityController = TextEditingController();
  // Estado para controlar qué escenario climático mostrar
  String _currentScenario =
      'default'; // 'default', 'temperature', 'humidity', 'wind', 'clouds'

  // Sobrescribe initState, que se llama al inicializar el widget.
  @override
  void initState() {
    // Llama al método padre.
    super.initState();
    // Prueba la conexión a la API al inicio.
    _testApiConnection();
    // Carga el clima predeterminado de Bogotá.
    _loadDefaultWeather();
  }

  // Método asíncrono para probar la conexión a la API.
  void _testApiConnection() async {
    // Llama al método de prueba del servicio.
    final isConnected = await _weatherService.testApiConnection();
    // Actualiza el estado con el resultado (causa rebuild de UI).
    setState(() {
      _isApiConnected = isConnected;
    });
  }

  // Método asíncrono para cargar el clima predeterminado.
  void _loadDefaultWeather() async {
    // Obtiene el clima para Bogotá.
    await _getWeather('Bogotá');
  }

  // Método asíncrono para obtener el clima de una ciudad específica.
  Future<void> _getWeather(String city) async {
    // Actualiza el estado para mostrar carga y limpiar errores.
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Bloque try para la solicitud.
    try {
      // Llama al servicio para obtener los datos.
      final weather = await _weatherService.getCurrentWeather(city);
      // Actualiza el estado con los datos y detiene la carga.
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
      // Captura errores.
    } catch (e) {
      // Actualiza el estado con el error y detiene la carga.
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Método para buscar clima basado en el texto del controlador.
  void _searchWeather() {
    // Verifica si el texto no está vacío.
    if (_cityController.text.isNotEmpty) {
      // Llama a _getWeather con el texto ingresado.
      _getWeather(_cityController.text);
    }
  }

  // Método para cambiar el escenario climático
  void _changeScenario(String scenario) {
    setState(() {
      _currentScenario = scenario;
    });
  }

  // Métodos auxiliares para los escenarios
  Color _getScenarioColor(String scenario) {
    switch (scenario) {
      case 'temperature':
        return Colors.orange;
      case 'humidity':
        return Colors.blue;
      case 'wind':
        return Colors.green;
      case 'clouds':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getScenarioIcon(String scenario) {
    switch (scenario) {
      case 'temperature':
        return Icons.wb_sunny;
      case 'humidity':
        return Icons.water_drop;
      case 'wind':
        return Icons.air;
      case 'clouds':
        return Icons.cloud;
      default:
        return Icons.wb_cloudy;
    }
  }

  String _getScenarioName(String scenario) {
    switch (scenario) {
      case 'temperature':
        return 'Temperatura';
      case 'humidity':
        return 'Humedad';
      case 'wind':
        return 'Viento';
      case 'clouds':
        return 'Nubosidad';
      default:
        return 'Normal';
    }
  }

  // Método que construye el fondo dinámico según el escenario
  BoxDecoration _buildDynamicBackground() {
    switch (_currentScenario) {
      case 'temperature':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B35), // Naranja cálido
              Color(0xFFF7931E), // Amarillo anaranjado
              Color(0xFFFFB347), // Amarillo dorado
              Color(0xFFFF8C42), // Naranja rojizo
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'humidity':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A90E2), // Azul cielo
              Color(0xFF5BA0F2), // Azul claro
              Color(0xFF7BB3F7), // Azul más claro
              Color(0xFF93C5F8), // Azul muy claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'wind':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F4FD), // Azul muy claro
              Color(0xFFB3E5FC), // Azul cielo claro
              Color(0xFF81D4FA), // Azul cielo
              Color(0xFF4FC3F7), // Azul dodger
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case 'clouds':
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFCFD8DC), // Gris claro
              Color(0xFFB0BEC5), // Gris azulado
              Color(0xFF90A4AE), // Gris medio
              Color(0xFF78909C), // Gris azulado oscuro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      default:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4CA1AF), // teal-blue
              Color(0xFFC4E0E5), // soft cyan
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
    }
  }

  // Método para obtener colores dinámicos según el escenario
  Color _getDynamicPrimaryColor() {
    switch (_currentScenario) {
      case 'temperature':
        return Colors.orange[800]!;
      case 'humidity':
        return Colors.blue[800]!;
      case 'wind':
        return Colors.green[800]!;
      case 'clouds':
        return Colors.grey[800]!;
      default:
        return Colors.blue[800]!;
    }
  }

  Color _getDynamicSecondaryColor() {
    switch (_currentScenario) {
      case 'temperature':
        return Colors.orange[600]!;
      case 'humidity':
        return Colors.blue[600]!;
      case 'wind':
        return Colors.green[600]!;
      case 'clouds':
        return Colors.grey[600]!;
      default:
        return Colors.blue[600]!;
    }
  }

  Color _getDynamicAccentColor() {
    switch (_currentScenario) {
      case 'temperature':
        return Colors.yellow[600]!;
      case 'humidity':
        return Colors.cyan[400]!;
      case 'wind':
        return Colors.teal[400]!;
      case 'clouds':
        return Colors.blueGrey[400]!;
      default:
        return Colors.lightBlue[400]!;
    }
  }

  // Método que construye un ícono dinámico basado en la descripción del clima.
  Widget _buildWeatherIcon(String description) {
    // Variable para el ícono.
    IconData icon;
    // Variable para el color del ícono.
    Color color;

    // Si la descripción contiene 'lluvia', asigna ícono de paraguas y color azul.
    if (description.contains('lluvia')) {
      icon = Icons.umbrella;
      color = Colors.blue;
      // Si contiene 'nube', asigna ícono de nube y color gris.
    } else if (description.contains('nube')) {
      icon = Icons.cloud;
      color = Colors.grey;
      // Si contiene 'sol' o 'despejado', asigna ícono de sol y color naranja.
    } else if (description.contains('sol') ||
        description.contains('despejado')) {
      icon = Icons.wb_sunny;
      color = Colors.orange;
      // Por defecto, ícono nublado y color azul grisáceo.
    } else {
      icon = Icons.wb_cloudy;
      color = Colors.blueGrey;
    }

    // Retorna un Icon widget con el ícono, color y tamaño responsive.
    return Icon(
      icon,
      color: color,
      size: ResponsiveHelper.getResponsiveFontSize(context, 80),
    );
  }

  // Método que construye una nube animada para el fondo.
  Widget _buildAnimatedCloud(int index) {
    // Velocidad base de la animación
    double baseDuration = 20.0 + index * 5.0;
    double opacity = 0.3;
    double size = 60.0 + index * 20.0;
    Color cloudColor = Colors.white;

    // Ajustes según el escenario
    switch (_currentScenario) {
      case 'wind':
        baseDuration = 6.0 + index * 2.0; // Más rápido para viento
        opacity = 0.5;
        break;
      case 'clouds':
        baseDuration = 25.0 + index * 8.0; // Más lento para nubes
        opacity = 0.6;
        size = 80.0 + index * 30.0; // Más grandes
        cloudColor = Colors.grey[300]!;
        break;
      case 'temperature':
        opacity = 0.2; // Menos visibles en sol
        cloudColor = Colors.white.withOpacity(0.7);
        break;
      case 'humidity':
        opacity = 0.4;
        cloudColor = Colors.blueGrey[200]!;
        break;
    }

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(seconds: baseDuration.toInt()),
      builder: (context, double value, child) {
        return Positioned(
          left: (value * MediaQuery.of(context).size.width) - (index * 120.0),
          top: 20 + index * 50.0,
          child: Opacity(
            opacity: opacity,
            child: Icon(Icons.cloud, color: cloudColor, size: size),
          ),
        );
      },
    );
  }

  // Método que construye gotas de agua animadas para el escenario de humedad
  Widget _buildAnimatedRainDrops() {
    if (_currentScenario != 'humidity') return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: List.generate(15, (index) {
          return TweenAnimationBuilder(
            tween: Tween<double>(
              begin: -50,
              end: MediaQuery.of(context).size.height + 50,
            ),
            duration: Duration(seconds: 3 + (index % 3)),
            builder: (context, double value, child) {
              return Positioned(
                left: (index * 30.0) % MediaQuery.of(context).size.width,
                top: value,
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.blue.withOpacity(0.7),
                    size: 12 + (index % 3) * 4.0,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Método que construye partículas de sol para el escenario de temperatura
  Widget _buildSunParticles() {
    if (_currentScenario != 'temperature') return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: List.generate(20, (index) {
          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 2 * 3.14159),
            duration: Duration(seconds: 4 + (index % 4)),
            builder: (context, double value, child) {
              double radius = 100 + (index % 5) * 20.0;
              double x =
                  MediaQuery.of(context).size.width / 2 +
                  radius * math.cos(value + index);
              double y = 200 + radius * math.sin(value + index);

              return Positioned(
                left: x,
                top: y,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Método que construye partículas de viento para el escenario de viento
  Widget _buildWindParticles() {
    if (_currentScenario != 'wind') return const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: List.generate(15, (index) {
          return TweenAnimationBuilder(
            tween: Tween<double>(
              begin: -50,
              end: MediaQuery.of(context).size.width + 50,
            ),
            duration: Duration(seconds: 1 + (index % 3)),
            builder: (context, double value, child) {
              return Positioned(
                left: value,
                top:
                    100 +
                    (index * 30.0) % (MediaQuery.of(context).size.height - 200),
                child: Opacity(
                  opacity: 0.7,
                  child: Transform.rotate(
                    angle: math.pi / 4, // Rotación para simular movimiento
                    child: Icon(
                      Icons.air,
                      color: Colors.white.withOpacity(0.8),
                      size: 20 + (index % 3) * 8.0,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildWeatherCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String scenario,
  ) {
    return GestureDetector(
      onTap: () => _changeScenario(scenario),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // Ensure cards never collapse below a readable minimum height.
        constraints: const BoxConstraints(minHeight: 80.0),
        padding: ResponsiveHelper.getResponsivePadding(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                _currentScenario == scenario ? color : color.withOpacity(0.3),
            width: _currentScenario == scenario ? 2 : 1,
          ),
          boxShadow:
              _currentScenario == scenario
                  ? [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use provided constraints to scale icon and value area safely.
            // previous computedIconSize/valueAreaMaxHeight removed after refactor

            // If the available height is tiny, fall back to a compact layout
            // instead of letting everything shrink to invisibility.
            const double minVisibleHeight = 80.0;
            const double minCardHeight =
                110.0; // ensure a minimum readable (and larger) card height

            // If the available height is tiny, provide a compact but still readable
            // layout that guarantees the minimum card height instead of shrinking to
            // invisibility.
            if (constraints.maxHeight.isFinite &&
                constraints.maxHeight < minVisibleHeight) {
              // Fit to the available small height instead of forcing a minimum height.
              final availableH = math.max(1.0, constraints.maxHeight);
              // Compute a scale factor relative to our preferred minCardHeight so fonts and icon
              // shrink proportionally but remain readable.
              final scale = (availableH / minCardHeight).clamp(0.4, 1.0);
              final smallIconSize = math.max(
                12.0,
                math.min(
                  ResponsiveHelper.getResponsiveFontSize(context, 22) * scale,
                  28.0,
                ),
              );
              final titleFontSize = math.max(
                8.0,
                math.min(
                  ResponsiveHelper.getResponsiveFontSize(context, 11) * scale,
                  12.0,
                ),
              );
              final valueFontSize = math.max(
                9.0,
                math.min(
                  ResponsiveHelper.getResponsiveFontSize(context, 12) * scale,
                  14.0,
                ),
              );

              return SizedBox(
                width: constraints.maxWidth,
                height: availableH,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: smallIconSize),
                    SizedBox(height: math.max(4.0, 6.0 * scale)),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: math.max(2.0, 4.0 * scale)),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }

            // Compute an effective height (at least minCardHeight) to base font/icon sizes
            // ensuring legibility even when parent constraints are small.
            final effectiveH =
                (constraints.maxHeight.isFinite && constraints.maxHeight > 0)
                    ? math.max(constraints.maxHeight, minCardHeight)
                    : minCardHeight;

            final iconSize = math.min(
              ResponsiveHelper.getResponsiveFontSize(context, 30),
              effectiveH * 0.45,
            );
            final titleFont = math.min(
              ResponsiveHelper.getResponsiveFontSize(context, 12),
              effectiveH * 0.12,
            );
            final valueFont = math.min(
              ResponsiveHelper.getResponsiveFontSize(context, 16),
              effectiveH * 0.2,
            );

            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minCardHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: _currentScenario == scenario ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 8),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFont,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveSpacing(context, 4),
                  ),
                  // Texto del valor con tamaño calculado
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: valueFont,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Sobrescribe el método build para construir la UI completa.
  @override
  Widget build(BuildContext context) {
    // Scaffold como contenedor principal con scroll vertical.
    return Scaffold(
      // Fondo con gradiente dinámico según el escenario
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: _buildDynamicBackground(),
        child: SingleChildScrollView(
          // Padding responsive para márgenes.
          padding: ResponsiveHelper.getResponsivePadding(context),
          // Container con ancho máximo para diseño responsive (hasta 800px).
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            // Columna principal para organizar elementos verticalmente.
            child: Column(
              children: [
                // Nubes animadas en el fondo usando Stack
                SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      _buildAnimatedCloud(0),
                      _buildAnimatedCloud(1),
                      _buildAnimatedCloud(2),
                      _buildAnimatedRainDrops(),
                      _buildSunParticles(),
                      _buildWindParticles(),
                    ],
                  ),
                ),

                // Indicador de estado de API
                // Container para el banner de estado de conexión.
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  // Margen inferior para espaciado.
                  margin: EdgeInsets.only(
                    bottom: ResponsiveHelper.getResponsiveSpacing(context, 15),
                  ),
                  // Decoración con color condicional (verde para conectado, naranja para demo).
                  decoration: BoxDecoration(
                    color:
                        _isApiConnected
                            ? Colors.white.withOpacity(0.9)
                            : Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color:
                          _isApiConnected
                              ? Colors.green[300]!
                              : Colors.orange[300]!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  // Fila para alinear ícono, texto y botón.
                  child: Row(
                    children: [
                      // Ícono condicional (check para conectado, off para demo).
                      Icon(
                        _isApiConnected ? Icons.cloud_done : Icons.cloud_off,
                        color:
                            _isApiConnected
                                ? Colors.green[700]
                                : Colors.orange[700],
                        size: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          20,
                        ),
                      ),
                      // Espaciado horizontal.
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          8,
                        ),
                      ),
                      // Texto expandido con mensaje condicional.
                      Expanded(
                        child: Text(
                          _isApiConnected
                              ? '�️ API Real Conectada - Datos en tiempo real'
                              : '🔧 Modo Demo - Usando datos simulados',
                          style: TextStyle(
                            color:
                                _isApiConnected
                                    ? Colors.green[700]
                                    : Colors.orange[700],
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              12,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Si no está conectado, muestra botón para probar.
                      if (!_isApiConnected)
                        ElevatedButton(
                          // Acción del botón: reprobar conexión.
                          onPressed: _testApiConnection,
                          // Estilo con padding mínimo.
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.orange[700],
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(60, 30),
                          ),
                          // Texto del botón.
                          child: Text(
                            'Probar API',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Buscador de ciudad con estilo de clima
                // Container para el área de búsqueda con gradiente de cielo soleado.
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.lightBlue.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    // Sombra para profundidad visual.
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  // Columna para título y campos de entrada.
                  child: Column(
                    children: [
                      // Fila para ícono de ubicación y título.
                      Row(
                        children: [
                          // Ícono de ubicación en azul.
                          Icon(
                            Icons.location_on,
                            color: Colors.blue[700],
                            size: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              24,
                            ),
                          ),
                          // Espaciado.
                          SizedBox(
                            width: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
                            ),
                          ),
                          // Título "Consultar Clima" en azul y negrita.
                          Text(
                            '🌤️ Consultar Clima',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                20,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Espaciado vertical.
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          15,
                        ),
                      ),
                      // Diseño condicional: fila para desktop, columna para móvil.
                      ResponsiveHelper.isDesktop(context)
                          ? Row(
                            children: [
                              // Campo de texto expandido para desktop.
                              Expanded(
                                child: TextField(
                                  // Asigna el controlador para leer el texto.
                                  controller: _cityController,
                                  decoration: InputDecoration(
                                    // Texto de placeholder.
                                    hintText: 'Ingresa una ciudad...',
                                    hintStyle: TextStyle(
                                      color: Colors.blueGrey[400],
                                      fontSize:
                                          ResponsiveHelper.getResponsiveFontSize(
                                            context,
                                            14,
                                          ),
                                    ),
                                    // Borde outline azul.
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    // Borde habilitado azul.
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[300]!,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    // Borde enfocado más grueso.
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue[600]!,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    // Padding interno responsive.
                                    contentPadding:
                                        ResponsiveHelper.getResponsivePadding(
                                          context,
                                        ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.8),
                                  ),
                                  // Estilo del texto en azul oscuro.
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          16,
                                        ),
                                  ),
                                  // Acción al presionar Enter: buscar.
                                  onSubmitted: (_) => _searchWeather(),
                                ),
                              ),
                              // Espaciado horizontal.
                              SizedBox(
                                width: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  10,
                                ),
                              ),
                              // Botón de búsqueda para desktop (solo ícono).
                              ElevatedButton(
                                // Acción: buscar clima.
                                onPressed: _searchWeather,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  padding:
                                      ResponsiveHelper.getResponsivePadding(
                                        context,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                // Ícono de búsqueda.
                                child: Icon(
                                  Icons.search,
                                  size: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    20,
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              // Campo de texto para móvil.
                              TextField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  hintText: 'Ingresa una ciudad...',
                                  hintStyle: TextStyle(
                                    color: Colors.blueGrey[400],
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          14,
                                        ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue[600]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding:
                                      ResponsiveHelper.getResponsivePadding(
                                        context,
                                      ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.8),
                                ),
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        16,
                                      ),
                                ),
                                onSubmitted: (_) => _searchWeather(),
                              ),
                              // Espaciado vertical.
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  10,
                                ),
                              ),
                              // Botón de búsqueda expandido para móvil.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _searchWeather,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    padding:
                                        ResponsiveHelper.getResponsivePadding(
                                          context,
                                        ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  // Fila con ícono y texto "Buscar".
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              20,
                                            ),
                                      ),
                                      SizedBox(
                                        width:
                                            ResponsiveHelper.getResponsiveSpacing(
                                              context,
                                              8,
                                            ),
                                      ),
                                      Text(
                                        'Buscar',
                                        style: TextStyle(
                                          fontSize:
                                              ResponsiveHelper.getResponsiveFontSize(
                                                context,
                                                16,
                                              ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),

                // Espaciado vertical después del buscador.
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(context, 20),
                ),

                // Contenido del clima
                // Si está cargando, muestra indicador de progreso.
                if (_isLoading)
                  Container(
                    // Altura fija responsive.
                    height: ResponsiveHelper.isDesktop(context) ? 250 : 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Spinner de carga con colores de clima.
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue[600]!,
                            ),
                            strokeWidth: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              4,
                            ),
                          ),
                          // Espaciado.
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              16,
                            ),
                          ),
                          // Texto de estado de carga.
                          Text(
                            '🌤️ Cargando datos del clima...',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Si hay error, muestra mensaje de error.
                else if (_error != null)
                  Container(
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Ícono de error en rojo.
                        Icon(
                          Icons.error,
                          color: Colors.white,
                          size: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            50,
                          ),
                        ),
                        // Espaciado.
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            10,
                          ),
                        ),
                        // Título del error.
                        Text(
                          '⛈️ Error al cargar el clima',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              18,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        // Espaciado.
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            8,
                          ),
                        ),
                        // Detalle del error centrado.
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              14,
                            ),
                          ),
                        ),
                        // Espaciado.
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            15,
                          ),
                        ),
                        // Botón para reintentar carga predeterminada.
                        ElevatedButton(
                          onPressed: _loadDefaultWeather,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red[700],
                            padding: ResponsiveHelper.getResponsivePadding(
                              context,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Reintentar',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                // Si hay datos de clima, muestra el contenido principal.
                else if (_weather != null)
                  Column(
                    children: [
                      // Información principal - tarjeta grande con glassmorphism
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            width: double.infinity,
                            padding: ResponsiveHelper.getResponsivePadding(
                              context,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.06),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.14),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icono grande con animación al cambiar descripción
                                AnimatedScale(
                                  scale: 1.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: _buildWeatherIcon(
                                    _weather!.description,
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    12,
                                  ),
                                ),
                                // Datos principales
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _weather!.location,
                                        style: TextStyle(
                                          color: _getDynamicPrimaryColor(),
                                          fontSize:
                                              ResponsiveHelper.getResponsiveFontSize(
                                                context,
                                                22,
                                              ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            ResponsiveHelper.getResponsiveSpacing(
                                              context,
                                              6,
                                            ),
                                      ),
                                      Text(
                                        _weather!.capitalizedDescription,
                                        style: TextStyle(
                                          color: _getDynamicSecondaryColor(),
                                          fontSize:
                                              ResponsiveHelper.getResponsiveFontSize(
                                                context,
                                                14,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Temperatura grande a la derecha
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _weather!.temperatureCelsius,
                                      style: TextStyle(
                                        color: _getDynamicPrimaryColor(),
                                        fontSize:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              44,
                                            ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${_weather!.temperatureCelsius}',
                                      style: TextStyle(
                                        color: _getDynamicSecondaryColor(),
                                        fontSize:
                                            ResponsiveHelper.getResponsiveFontSize(
                                              context,
                                              12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Espaciado vertical.
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          20,
                        ),
                      ),

                      // Indicador de escenario activo y botón de reset
                      if (_currentScenario != 'default')
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          padding: ResponsiveHelper.getResponsivePadding(
                            context,
                          ),
                          margin: EdgeInsets.only(
                            bottom: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              15,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getScenarioColor(
                                _currentScenario,
                              ).withOpacity(0.7),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _getScenarioColor(
                                  _currentScenario,
                                ).withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getScenarioIcon(_currentScenario),
                                color: _getScenarioColor(_currentScenario),
                              ),
                              SizedBox(
                                width: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  8,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Escenario: ${_getScenarioName(_currentScenario)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          14,
                                        ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _changeScenario('default'),
                                child: Text('Reset'),
                              ),
                            ],
                          ),
                        ),

                      // Métricas detalladas: tarjetas grandes y visuales
                      LayoutBuilder(
                        builder: (context, gridConstraints) {
                          final columns =
                              ResponsiveHelper.isDesktop(context) ? 4 : 2;
                          final double spacing =
                              ResponsiveHelper.getResponsiveSpacing(
                                context,
                                12,
                              );
                          // Larger card height for better legibility
                          const double cardH = 140.0;

                          // Compute aspect ratio for stable sizing
                          final double availableWidth =
                              gridConstraints.maxWidth.isFinite &&
                                      gridConstraints.maxWidth > 0
                                  ? gridConstraints.maxWidth
                                  : MediaQuery.of(context).size.width;
                          final tileWidth =
                              (availableWidth - (columns - 1) * spacing) /
                              columns;

                          return GridView.count(
                            crossAxisCount: columns,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: tileWidth / cardH,
                            children: [
                              _buildWeatherCard(
                                'Sensación',
                                _weather!.feelsLikeCelsius,
                                Icons.thermostat_outlined,
                                Colors.deepOrange,
                                'temperature',
                              ),
                              _buildWeatherCard(
                                'Humedad',
                                _weather!.humidityPercent,
                                Icons.water_drop,
                                Colors.blueAccent,
                                'humidity',
                              ),
                              _buildWeatherCard(
                                'Viento',
                                _weather!.windSpeedKmh,
                                Icons.air,
                                Colors.greenAccent,
                                'wind',
                              ),
                              _buildWeatherCard(
                                'Nubosidad',
                                _weather!.precipitationPercent,
                                Icons.cloud_queue,
                                Colors.blueGrey,
                                'clouds',
                              ),
                            ],
                          );
                        },
                      ),

                      // Espaciado vertical.
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          20,
                        ),
                      ),

                      // Sugerencias de ciudades con estilo de clima
                      // Container para la sección de sugerencias con fondo de cielo.
                      Container(
                        padding: ResponsiveHelper.getResponsivePadding(context),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título de la sección.
                            Text(
                              '🏙️ Ciudades Sugeridas',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      16,
                                    ),
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                            // Espaciado.
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                10,
                              ),
                            ),
                            // Wrap para chips de ciudades que se envuelven en múltiples líneas.
                            Wrap(
                              spacing: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                8,
                              ),
                              runSpacing: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                8,
                              ),
                              // Mapea la lista de sugerencias a GestureDetector interactivos.
                              children:
                                  _weatherService.getCitySuggestions().map((
                                    city,
                                  ) {
                                    // Cada chip es un GestureDetector para tocar y buscar.
                                    return GestureDetector(
                                      // Acción al tocar: setea texto y busca clima.
                                      onTap: () {
                                        _cityController.text = city;
                                        _getWeather(city);
                                      },
                                      // Container para el chip con fondo azul cielo.
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveHelper.getResponsiveSpacing(
                                                context,
                                                12,
                                              ),
                                          vertical:
                                              ResponsiveHelper.getResponsiveSpacing(
                                                context,
                                                6,
                                              ),
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue[100]!,
                                              Colors.blue[200]!,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: Colors.blue[300]!,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(
                                                0.2,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        // Texto de la ciudad en azul oscuro.
                                        child: Text(
                                          city,
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontSize:
                                                ResponsiveHelper.getResponsiveFontSize(
                                                  context,
                                                  12,
                                                ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sobrescribe dispose para limpiar recursos al destruir el widget.
  @override
  void dispose() {
    // Libera el controlador de texto para evitar memory leaks.
    _cityController.dispose();
    // Llama al método padre.
    super.dispose();
  }
}
