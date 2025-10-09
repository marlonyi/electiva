// Importa la biblioteca dart:convert para manejar conversiones de JSON, como decodificar respuestas de API.
import 'dart:convert';
// Importa el paquete http con un alias 'http' para realizar solicitudes HTTP a la API.
import 'package:http/http.dart' as http;
// Importa el modelo WeatherModel desde el directorio models, que representa los datos del clima en Dart.
import '../models/weather_model.dart';

// Define la clase WeatherService, que encapsula la lógica para interactuar con la API de OpenWeatherMap.
class WeatherService {
  // Campo para inyectar el cliente HTTP (permite mockear en tests).
  final http.Client client;

  // Constructor con inyección de dependencias opcional.
  // Si no se proporciona un cliente, usa el cliente HTTP estándar.
  WeatherService({http.Client? client}) : client = client ?? http.Client();

  // Declara una constante estática para la clave de la API de OpenWeatherMap; reemplázala con tu clave real.
  // Nota: En producción, usa variables de entorno para seguridad.
  static const String _apiKey = '24e81c1e3a7f45b4eb4d8e2588f14ed0';
  // Declara una constante estática para la URL base de la API de OpenWeatherMap (versión 2.5).
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Define un mapa constante con datos simulados (mock) de clima para Bogotá, usado como respaldo en caso de errores.
  // Estructura idéntica a la respuesta real de la API para compatibilidad con WeatherModel.
  static const Map<String, dynamic> _mockData = {
    // Coordenadas de la ciudad (longitud y latitud).
    "coord": {"lon": -74.0817, "lat": 4.6097},
    // Array con detalles del clima actual (solo un elemento en este mock).
    "weather": [
      {
        // ID del tipo de clima (803 para nubes dispersas).
        "id": 803,
        // Categoría principal del clima.
        "main": "Clouds",
        // Descripción en español.
        "description": "nubes dispersas",
        // Código del ícono para mostrar en la UI.
        "icon": "04d",
      },
    ],
    // Base de datos de estaciones meteorológicas.
    "base": "stations",
    // Datos principales del clima.
    "main": {
      // Temperatura actual en °C.
      "temp": 22.5,
      // Sensación térmica en °C.
      "feels_like": 24.2,
      // Temperatura mínima.
      "temp_min": 20.1,
      // Temperatura máxima.
      "temp_max": 25.3,
      // Presión atmosférica en hPa.
      "pressure": 1013,
      // Humedad relativa en %.
      "humidity": 65,
    },
    // Visibilidad en metros.
    "visibility": 10000,
    // Datos del viento.
    "wind": {"speed": 3.2, "deg": 180},
    // Datos de nubosidad.
    "clouds": {"all": 40},
    // Timestamp Unix del momento de la medición.
    "dt": 1727635200,
    // Datos del sistema solar.
    "sys": {
      // Tipo de estación.
      "type": 1,
      // ID de la estación.
      "id": 8582,
      // Código del país.
      "country": "CO",
      // Timestamp de amanecer.
      "sunrise": 1727606400,
      // Timestamp de atardecer.
      "sunset": 1727649600,
    },
    // Zona horaria en segundos respecto a UTC.
    "timezone": -18000,
    // ID de la ciudad en la base de datos de OpenWeatherMap.
    "id": 3688689,
    // Nombre de la ciudad.
    "name": "Bogotá",
    // Código de respuesta HTTP (200 para éxito).
    "cod": 200,
  };

  // Método asíncrono que obtiene el clima actual para una ciudad dada; retorna un objeto WeatherModel.
  Future<WeatherModel> getCurrentWeather(String city) async {
    // Bloque try para manejar la solicitud a la API y posibles errores.
    try {
      // Construye la URI para la solicitud GET con parámetros para ciudad, clave API, unidades métricas y idioma español.
      final url = Uri.parse(
        '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=es',
      );
      // Realiza la solicitud HTTP GET a la URL construida usando el cliente inyectado y espera la respuesta.
      final response = await client.get(url);

      // Verifica si el código de estado es 200 (éxito).
      if (response.statusCode == 200) {
        // Decodifica el cuerpo de la respuesta (JSON) en un mapa dinámico.
        final data = json.decode(response.body);
        // Convierte el mapa en un objeto WeatherModel usando el factory fromJson.
        return WeatherModel.fromJson(data);
        // Maneja error 401 (clave API inválida).
      } else if (response.statusCode == 401) {
        // Lanza una excepción con mensaje descriptivo para el usuario.
        throw Exception(
          'API Key inválida. Verifica tu clave en OpenWeatherMap.',
        );
        // Maneja error 404 (ciudad no encontrada).
      } else if (response.statusCode == 404) {
        // Lanza una excepción con mensaje que incluye el nombre de la ciudad.
        throw Exception(
          'Ciudad "$city" no encontrada. Intenta con otro nombre.',
        );
        // Maneja otros códigos de error del servidor.
      } else {
        // Lanza una excepción genérica con el código de estado.
        throw Exception('Error del servidor: ${response.statusCode}');
      }
      // Captura cualquier excepción (red, parsing, etc.) en el bloque catch.
    } catch (e) {
      // Imprime un mensaje de depuración en la consola sobre el error y el uso de datos demo.
      print('⚠️ Error API: $e - Usando datos demo como respaldo');
      // Simula un retraso para una mejor experiencia de usuario en modo fallback.
      await Future.delayed(const Duration(seconds: 1));
      // Retorna un WeatherModel creado a partir de los datos mock simulados.
      return WeatherModel.fromJson(_mockData);
    }
  }

  // Método asíncrono que obtiene el clima basado en coordenadas geográficas; retorna un objeto WeatherModel.
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    // Bloque try para manejar la solicitud por coordenadas.
    try {
      // Construye la URI con parámetros para latitud, longitud, clave API, unidades y idioma.
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es',
      );
      // Realiza la solicitud HTTP GET usando el cliente inyectado.
      final response = await client.get(url);

      // Verifica éxito (código 200).
      if (response.statusCode == 200) {
        // Decodifica el JSON y crea el modelo.
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
        // Maneja errores HTTP genéricos.
      } else {
        // Lanza excepción con el código de estado.
        throw Exception('Error HTTP: ${response.statusCode}');
      }
      // Captura errores en catch.
    } catch (e) {
      // Imprime mensaje de depuración.
      print('⚠️ Error API coordenadas: $e - Usando datos demo');
      // Retorna modelo desde datos mock.
      return WeatherModel.fromJson(_mockData);
    }
  }

  // Método para probar la API Key con diagnóstico; retorna un booleano indicando si la conexión es exitosa.
  Future<bool> testApiConnection() async {
    // Bloque try para la prueba de conexión.
    try {
      // Construye URI de prueba para Londres (ciudad estándar para pruebas).
      final url = Uri.parse(
        '$_baseUrl/weather?q=London&appid=$_apiKey&units=metric',
      );
      // Imprime la URL de prueba para depuración.
      print('🔍 Probando API: $url');
      // Realiza la solicitud GET usando el cliente inyectado.
      final response = await client.get(url);

      // Imprime el código de estado de la respuesta.
      print('📡 Respuesta API: ${response.statusCode}');
      // Si no es 200, imprime el cuerpo de la respuesta para diagnóstico.
      if (response.statusCode != 200) {
        print('❌ Error body: ${response.body}');
        // Si es 200, confirma éxito.
      } else {
        print('✅ API Key funcional!');
      }

      // Retorna true si la conexión fue exitosa.
      return response.statusCode == 200;
      // Captura errores de conexión.
    } catch (e) {
      // Imprime el error.
      print('🚫 Error conexión: $e');
      // Retorna false.
      return false;
    }
  }

  // Método que retorna una lista estática de sugerencias de ciudades para la UI.
  List<String> getCitySuggestions() {
    // Retorna una lista de ciudades comunes (colombianas e internacionales) para chips interactivos.
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
