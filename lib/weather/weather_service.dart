import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Cliente HTTP inyectable (útil para tests)
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  // API key leída en tiempo de compilación (flutter run/build --dart-define)
  static const String _apiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '24e81c1e3a7f45b4eb4d8e2588f14ed0',
  );

  // Base correcta de OpenWeatherMap
  static const String _baseHost = 'api.openweathermap.org';
  static const String _basePath = '/data/2.5';

  // Datos mock (fallback) con la misma estructura básica que la API real.
  static const Map<String, dynamic> _mockData = {
    "coord": {"lon": -74.0817, "lat": 4.6097},
    "weather": [
      {
        "id": 803,
        "main": "Clouds",
        "description": "nubes dispersas",
        "icon": "04d",
      },
    ],
    "base": "stations",
    "main": {
      "temp": 22.5,
      "feels_like": 24.2,
      "temp_min": 20.1,
      "temp_max": 25.3,
      "pressure": 1013,
      "humidity": 65,
    },
    "visibility": 10000,
    "wind": {"speed": 3.2, "deg": 180},
    "clouds": {"all": 40},
    "dt": 1727635200,
    "sys": {
      "type": 1,
      "id": 8582,
      "country": "CO",
      "sunrise": 1727606400,
      "sunset": 1727649600,
    },
    "timezone": -18000,
    "id": 3688689,
    "name": "Bogotá",
    "cod": 200,
  };

  // Obtiene el clima por nombre de ciudad.
  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      // Construye URI seguro:
      late final Uri uri;
      if (_apiKey.isEmpty) {
        // Forzar "appid=" en la URL incluso si la key está vacía (útil para tests)
        final encodedCity = Uri.encodeComponent(city);
        uri = Uri.parse('https://$_baseHost$_basePath/weather?q=$encodedCity&appid=&units=metric&lang=es');
      } else {
        uri = Uri.https(
          _baseHost,
          '$_basePath/weather',
          {
            'q': city,
            'appid': _apiKey,
            'units': 'metric',
            'lang': 'es',
          },
        );
      }

      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('API Key inválida. Verifica tu clave en OpenWeatherMap.');
      } else if (response.statusCode == 404) {
        throw Exception('Ciudad "$city" no encontrada. Intenta con otro nombre.');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      // Log y fallback a datos mock para mantener la UI funcional
      print('⚠️ Error API (getCurrentWeather): $e - Usando datos demo como respaldo');
      await Future.delayed(const Duration(seconds: 1));
      return WeatherModel.fromJson(_mockData);
    }
  }

  // Obtiene el clima por coordenadas (lat, lon).
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      late final Uri uri;
      if (_apiKey.isEmpty) {
        // Forzar "appid=" incluso si la key está vacía
        uri = Uri.parse('https://$_baseHost$_basePath/weather?lat=${lat.toString()}&lon=${lon.toString()}&appid=&units=metric&lang=es');
      } else {
        uri = Uri.https(
          _baseHost,
          '$_basePath/weather',
          {
            'lat': lat.toString(),
            'lon': lon.toString(),
            'appid': _apiKey,
            'units': 'metric',
            'lang': 'es',
          },
        );
      }

      final response = await client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error API coordenadas: $e - Usando datos demo');
      return WeatherModel.fromJson(_mockData);
    }
  }

  // Prueba rápida para verificar que la API key y la conexión funcionan.
  Future<bool> testApiConnection() async {
    try {
      late final Uri uri;
      if (_apiKey.isEmpty) {
        uri = Uri.parse('https://$_baseHost$_basePath/weather?q=London&appid=&units=metric');
      } else {
        uri = Uri.https(
          _baseHost,
          '$_basePath/weather',
          {
            'q': 'London',
            'appid': _apiKey,
            'units': 'metric',
          },
        );
      }

      print('🔍 Probando API: $uri');
      final response = await client.get(uri).timeout(const Duration(seconds: 10));
      print('📡 Respuesta API: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('❌ Error body: ${response.body}');
      } else {
        print('✅ API Key funcional!');
      }
      return response.statusCode == 200;
    } catch (e) {
      print('🚫 Error conexión (testApiConnection): $e');
      return false;
    }
  }

  // Sugerencias de ciudades para la UI (autocompletar / chips).
  List<String> getCitySuggestions() {
    return [
      'Bogotá',
      'Medellín',
      'Cali',
      'Barranquilla',
      'Cartagena',
      'Bucaramanga',
      'Pereira',
      'Manizales',
      'Santa Marta',
      'Ibagué',
      'London',
      'New York',
      'Tokyo',
      'Paris',
      'Madrid',
    ];
  }
}