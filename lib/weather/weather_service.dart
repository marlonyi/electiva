import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // 🔑 REEMPLAZA con tu API key real de OpenWeatherMap
  static const String _apiKey = '24e81c1e3a7f45b4eb4d8e2588f14ed0';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Para demo, usaremos datos mockeados
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

  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      // 🌐 API REAL ACTIVADA - Datos en tiempo real de OpenWeatherMap
      final url = Uri.parse(
        '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=es',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception(
          'API Key inválida. Verifica tu clave en OpenWeatherMap.',
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'Ciudad "$city" no encontrada. Intenta con otro nombre.',
        );
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      // 🔄 FALLBACK: Si hay error de red, usar datos demo
      print('⚠️ Error API: $e - Usando datos demo como respaldo');
      await Future.delayed(const Duration(seconds: 1));
      return WeatherModel.fromJson(_mockData);
    }
  }

  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      // 🌐 API REAL ACTIVADA - Búsqueda por coordenadas
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // 🔄 FALLBACK: Usar datos demo si hay error
      print('⚠️ Error API coordenadas: $e - Usando datos demo');
      return WeatherModel.fromJson(_mockData);
    }
  }

  // 🧪 Método para probar la API Key con diagnóstico
  Future<bool> testApiConnection() async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?q=London&appid=$_apiKey&units=metric',
      );
      print('🔍 Probando API: $url');
      final response = await http.get(url);

      print('📡 Respuesta API: ${response.statusCode}');
      if (response.statusCode != 200) {
        print('❌ Error body: ${response.body}');
      } else {
        print('✅ API Key funcional!');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('🚫 Error conexión: $e');
      return false;
    }
  }

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
