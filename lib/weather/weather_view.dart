import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/responsive_helper.dart';
import 'weather_service.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _error;
  bool _isApiConnected = false;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testApiConnection();
    _loadDefaultWeather();
  }

  void _testApiConnection() async {
    final isConnected = await _weatherService.testApiConnection();
    setState(() {
      _isApiConnected = isConnected;
    });
  }

  void _loadDefaultWeather() async {
    await _getWeather('Bogotá');
  }

  Future<void> _getWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _searchWeather() {
    if (_cityController.text.isNotEmpty) {
      _getWeather(_cityController.text);
    }
  }

  Widget _buildWeatherIcon(String description) {
    IconData icon;
    Color color;

    if (description.contains('lluvia')) {
      icon = Icons.umbrella;
      color = Colors.blue;
    } else if (description.contains('nube')) {
      icon = Icons.cloud;
      color = Colors.grey;
    } else if (description.contains('sol') ||
        description.contains('despejado')) {
      icon = Icons.wb_sunny;
      color = Colors.orange;
    } else {
      icon = Icons.wb_cloudy;
      color = Colors.blueGrey;
    }

    return Icon(
      icon,
      color: color,
      size: ResponsiveHelper.getResponsiveFontSize(context, 80),
    );
  }

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 4)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // Indicador de estado de API
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
                margin: EdgeInsets.only(
                  bottom: ResponsiveHelper.getResponsiveSpacing(context, 15),
                ),
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
                child: Row(
                  children: [
                    Icon(
                      _isApiConnected ? Icons.cloud_done : Icons.cloud_off,
                      color:
                          _isApiConnected
                              ? Colors.green[700]
                              : Colors.orange[700],
                      size: ResponsiveHelper.getResponsiveFontSize(context, 20),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSpacing(context, 8),
                    ),
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
                    if (!_isApiConnected)
                      TextButton(
                        onPressed: _testApiConnection,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(60, 30),
                        ),
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
              Container(
                padding: ResponsiveHelper.getResponsivePadding(context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            24,
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            8,
                          ),
                        ),
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
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                    ),
                    ResponsiveHelper.isDesktop(context)
                        ? Row(
                          children: [
                            Expanded(
                              child: TextField(
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
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                10,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _searchWeather,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue[600],
                                padding: ResponsiveHelper.getResponsivePadding(
                                  context,
                                ),
                              ),
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
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                10,
                              ),
                            ),
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

              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(context, 20),
              ),

              // Contenido del clima
              if (_isLoading)
                Container(
                  height: ResponsiveHelper.isDesktop(context) ? 250 : 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            4,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            16,
                          ),
                        ),
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
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          50,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          10,
                        ),
                      ),
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
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          8,
                        ),
                      ),
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
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          15,
                        ),
                      ),
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
              else if (_weather != null)
                Column(
                  children: [
                    // Información principal
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
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              10,
                            ),
                          ),
                          _buildWeatherIcon(_weather!.description),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              15,
                            ),
                          ),
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

                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        20,
                      ),
                    ),

                    // Métricas detalladas
                    GridView.count(
                      crossAxisCount:
                          ResponsiveHelper.isDesktop(context) ? 4 : 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                      mainAxisSpacing: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        15,
                      ),
                      children: [
                        _buildWeatherCard(
                          'Sensación Térmica',
                          _weather!.feelsLikeCelsius,
                          Icons.thermostat,
                          Colors.orange,
                        ),
                        _buildWeatherCard(
                          'Humedad',
                          _weather!.humidityPercent,
                          Icons.water_drop,
                          Colors.blue,
                        ),
                        _buildWeatherCard(
                          'Viento',
                          _weather!.windSpeedKmh,
                          Icons.air,
                          Colors.green,
                        ),
                        _buildWeatherCard(
                          'Nubosidad',
                          _weather!.precipitationPercent,
                          Icons.cloud,
                          Colors.grey,
                        ),
                      ],
                    ),

                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        20,
                      ),
                    ),

                    // Sugerencias de ciudades
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
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              10,
                            ),
                          ),
                          Wrap(
                            spacing: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
                            ),
                            runSpacing: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
                            ),
                            children:
                                _weatherService.getCitySuggestions().map((
                                  city,
                                ) {
                                  return GestureDetector(
                                    onTap: () {
                                      _cityController.text = city;
                                      _getWeather(city);
                                    },
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

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
