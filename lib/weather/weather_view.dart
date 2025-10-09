// Importa el paquete de Material Design para UI.
import 'package:flutter/material.dart';
// Importa el modelo de clima para usar en la vista.
import '../models/weather_model.dart';
// Importa un helper para diseño responsive (ajusta UI según tamaño de pantalla).
import '../utils/responsive_helper.dart';
// Importa el servicio de clima para interactuar con la API.
import 'weather_service.dart';

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

  // Método que construye una tarjeta de información del clima con título, valor, ícono y color.
  Widget _buildWeatherCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {
  return Container(
    padding: ResponsiveHelper.getResponsivePadding(context),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: ResponsiveHelper.getResponsiveFontSize(context, 30),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 4)),
            // Evita overflow escalando el texto al espacio disponible
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight * 0.35,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

  // Sobrescribe el método build para construir la UI completa.
  @override
  Widget build(BuildContext context) {
    // Scaffold como contenedor principal con scroll vertical.
    return Scaffold(
      body: SingleChildScrollView(
        // Padding responsive para márgenes.
        padding: ResponsiveHelper.getResponsivePadding(context),
        // Container con ancho máximo para diseño responsive (hasta 800px).
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          // Columna principal para organizar elementos verticalmente.
          child: Column(
            children: [
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
                  color: _isApiConnected ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        _isApiConnected
                            ? Colors.green[300]!
                            : Colors.orange[300]!,
                  ),
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
                      size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                    ),
                    // Espaciado horizontal.
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSpacing(context, 8),
                    ),
                    // Texto expandido con mensaje condicional.
                    Expanded(
                      child: Text(
                        _isApiConnected
                            ? '🌐 API Real Conectada - Datos en tiempo real'
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
                      TextButton(
                        // Acción del botón: reprobar conexión.
                        onPressed: _testApiConnection,
                        // Estilo con padding mínimo.
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                        ),
                        // Texto del botón.
                        child: Text(
                          'Probar API',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Buscador de ciudad
              // Container para el área de búsqueda con gradiente azul.
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // Sombra para profundidad visual.
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
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
                        // Ícono de ubicación en blanco.
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
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
                        // Título "Consultar Clima" en blanco y negrita.
                        Text(
                          'Consultar Clima',
                          style: TextStyle(
                            color: Colors.white,
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
                                    color: Colors.white70,
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          14,
                                        ),
                                  ),
                                  // Borde outline blanco.
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  // Borde habilitado blanco.
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  // Borde enfocado más grueso.
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  // Padding interno responsive.
                                  contentPadding:
                                      ResponsiveHelper.getResponsivePadding(
                                        context,
                                      ),
                                ),
                                // Estilo del texto en blanco.
                                style: TextStyle(
                                  color: Colors.white,
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
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue[600],
                                padding: ResponsiveHelper.getResponsivePadding(
                                  context,
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
                                  color: Colors.white70,
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        14,
                                      ),
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                contentPadding:
                                    ResponsiveHelper.getResponsivePadding(
                                      context,
                                    ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
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
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue[600],
                                  padding:
                                      ResponsiveHelper.getResponsivePadding(
                                        context,
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Spinner de carga.
                        CircularProgressIndicator(
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
                          'Cargando datos del clima...',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
                            color: Colors.grey,
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
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Column(
                    children: [
                      // Ícono de error en rojo.
                      Icon(
                        Icons.error,
                        color: Colors.red,
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
                        'Error al cargar el clima',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            18,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
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
                          color: Colors.red,
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
                          padding: ResponsiveHelper.getResponsivePadding(
                            context,
                          ),
                        ),
                        child: Text(
                          'Reintentar',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              16,
                            ),
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
                    // Información principal
                    // Container para la tarjeta principal con gradiente índigo-púrpura.
                    Container(
                      width: double.infinity,
                      padding: ResponsiveHelper.getResponsivePadding(context),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo[400]!, Colors.purple[400]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        // Sombra para profundidad.
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Nombre de la ciudad en blanco y grande.
                          Text(
                            _weather!.location,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                28,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Espaciado.
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              10,
                            ),
                          ),
                          // Ícono dinámico basado en descripción.
                          _buildWeatherIcon(_weather!.description),
                          // Espaciado.
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              15,
                            ),
                          ),
                          // Temperatura principal en grande y ligera.
                          Text(
                            _weather!.temperatureCelsius,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                48,
                              ),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          // Descripción capitalizada en gris claro.
                          Text(
                            _weather!.capitalizedDescription,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Espaciado vertical.
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        20,
                      ),
                    ),

                    // Métricas detalladas
                    // GridView para mostrar tarjetas en 4 columnas desktop / 2 móvil.
                    GridView.count(
                      crossAxisCount:
                          ResponsiveHelper.isDesktop(context) ? 4 : 2,
                      // ShrinkWrap para que ocupe solo el espacio necesario en scroll.
                      shrinkWrap: true,
                      // Desactiva scroll interno del GridView.
                      physics: const NeverScrollableScrollPhysics(),
                      // Espaciado entre columnas.
                      crossAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                      // Espaciado entre filas.
                      mainAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                      children: [
                        // Tarjeta para sensación térmica.
                        _buildWeatherCard(
                          'Sensación Térmica',
                          _weather!.feelsLikeCelsius,
                          Icons.thermostat,
                          Colors.orange,
                        ),
                        // Tarjeta para humedad.
                        _buildWeatherCard(
                          'Humedad',
                          _weather!.humidityPercent,
                          Icons.water_drop,
                          Colors.blue,
                        ),
                        // Tarjeta para viento.
                        _buildWeatherCard(
                          'Viento',
                          _weather!.windSpeedKmh,
                          Icons.air,
                          Colors.green,
                        ),
                        // Tarjeta para nubosidad (usado precipitationPercent en el código original).
                        _buildWeatherCard(
                          'Nubosidad',
                          _weather!.precipitationPercent,
                          Icons.cloud,
                          Colors.grey,
                        ),
                      ],
                    ),

                    // Espaciado vertical.
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        20,
                      ),
                    ),

                    // Sugerencias de ciudades
                    // Container para la sección de sugerencias con fondo gris claro.
                    Container(
                      padding: ResponsiveHelper.getResponsivePadding(context),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de la sección.
                          Text(
                            '🏙️ Ciudades Sugeridas',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                16,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
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
                                    // Container para el chip con fondo azul claro.
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
                                        color: Colors.blue[100],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.blue[300]!,
                                        ),
                                      ),
                                      // Texto de la ciudad en azul oscuro.
                                      child: Text(
                                        city,
                                        style: TextStyle(
                                          color: Colors.blue[700],
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