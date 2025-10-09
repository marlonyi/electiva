import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:electiva/weather/weather_service.dart';

void main() {
  group('WeatherService', () {
    test('getCurrentWeather devuelve modelo cuando API responde 200', () async {
      // Arrange: preparar respuesta falsa de la API
      final mockJson = {
        "name": "London",
        "main": {"temp": 15.0, "feels_like": 13.0, "humidity": 70},
        "wind": {"speed": 5.0},
        "clouds": {"all": 20},
        "weather": [
          {"description": "few clouds", "icon": "02d"},
        ],
      };

      // Crear un cliente HTTP falso que devuelve la respuesta mock
      final mockClient = MockClient((request) async {
        // Verificar que la URL contiene la ciudad correcta
        expect(request.url.toString(), contains('London'));
        // Verificar que usa unidades métricas
        expect(request.url.toString(), contains('metric'));
        // Verificar que usa idioma español
        expect(request.url.toString(), contains('lang=es'));

        // Devolver respuesta exitosa (200)
        return http.Response(jsonEncode(mockJson), 200);
      });

      // Crear el servicio con el cliente mock inyectado
      final service = WeatherService(client: mockClient);

      // Act: llamar al servicio
      final result = await service.getCurrentWeather('London');

      // Assert: verificar que el resultado es correcto
      expect(result.location, 'London');
      expect(result.temperature, 15.0);
      expect(result.humidity, 70);
      expect(result.windSpeed, 5.0);
      expect(result.precipitation, 20);
    });

    test('getCurrentWeather usa fallback cuando API responde 500', () async {
      // Arrange: simular error de servidor
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = WeatherService(client: mockClient);

      // Act: llamar al servicio
      final result = await service.getCurrentWeather('Bogotá');

      // Assert: verificar que usa datos mock (fallback)
      // El mock data tiene "Bogotá" como location
      expect(result.location.toLowerCase(), contains('bogot'));
      expect(result.temperature, isNotNull);
      expect(result.humidity, isNotNull);
    });

    test('getCurrentWeather construye URL correctamente', () async {
      // Arrange
      String? capturedUrl;

      final mockClient = MockClient((request) async {
        capturedUrl = request.url.toString();

        final mockJson = {
          "name": "Test City",
          "main": {"temp": 20.0, "feels_like": 19.0, "humidity": 50},
          "wind": {"speed": 2.0},
          "clouds": {"all": 10},
          "weather": [
            {"description": "test", "icon": "01d"},
          ],
        };

        return http.Response(jsonEncode(mockJson), 200);
      });

      final service = WeatherService(client: mockClient);

      // Act
      await service.getCurrentWeather('Paris');

      // Assert: verificar estructura de la URL
      expect(capturedUrl, isNotNull);
      expect(capturedUrl, contains('api.openweathermap.org'));
      expect(capturedUrl, contains('/data/2.5/weather'));
      expect(capturedUrl, contains('q=Paris'));
      expect(capturedUrl, contains('units=metric'));
      expect(capturedUrl, contains('lang=es'));
      expect(capturedUrl, contains('appid='));
    });

    test(
      'getWeatherByCoordinates devuelve modelo cuando API responde 200',
      () async {
        // Arrange
        final mockJson = {
          "name": "Coordinate Location",
          "main": {"temp": 25.0, "feels_like": 26.0, "humidity": 60},
          "wind": {"speed": 3.5},
          "clouds": {"all": 30},
          "weather": [
            {"description": "sunny", "icon": "01d"},
          ],
        };

        final mockClient = MockClient((request) async {
          // Verificar que la URL contiene lat y lon
          expect(request.url.toString(), contains('lat='));
          expect(request.url.toString(), contains('lon='));

          return http.Response(jsonEncode(mockJson), 200);
        });

        final service = WeatherService(client: mockClient);

        // Act
        final result = await service.getWeatherByCoordinates(4.6097, -74.0817);

        // Assert
        expect(result.location, 'Coordinate Location');
        expect(result.temperature, 25.0);
        expect(result.humidity, 60);
      },
    );

    test('getWeatherByCoordinates usa fallback cuando falla', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });

      final service = WeatherService(client: mockClient);

      // Act
      final result = await service.getWeatherByCoordinates(0.0, 0.0);

      // Assert: debe usar datos mock
      expect(result.location, isNotNull);
      expect(result.temperature, isNotNull);
    });

    test('testApiConnection devuelve true cuando API responde 200', () async {
      // Arrange
      final mockJson = {
        "name": "London",
        "main": {"temp": 15.0, "feels_like": 14.0, "humidity": 70},
        "wind": {"speed": 5.0},
        "clouds": {"all": 20},
        "weather": [
          {"description": "cloudy", "icon": "03d"},
        ],
      };

      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode(mockJson), 200);
      });

      final service = WeatherService(client: mockClient);

      // Act
      final result = await service.testApiConnection();

      // Assert
      expect(result, true);
    });

    test('testApiConnection devuelve false cuando API falla', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final service = WeatherService(client: mockClient);

      // Act
      final result = await service.testApiConnection();

      // Assert
      expect(result, false);
    });

    test('testApiConnection devuelve false cuando hay error de red', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final service = WeatherService(client: mockClient);

      // Act
      final result = await service.testApiConnection();

      // Assert
      expect(result, false);
    });

    test('getCitySuggestions devuelve lista de ciudades', () {
      // Arrange
      final service = WeatherService();

      // Act
      final suggestions = service.getCitySuggestions();

      // Assert
      expect(suggestions, isNotEmpty);
      expect(suggestions, contains('Bogotá'));
      expect(suggestions, contains('London'));
      expect(suggestions, contains('New York'));
      expect(suggestions, isA<List<String>>());
      expect(suggestions.length, greaterThan(10));
    });

    test(
      'getCurrentWeather maneja error de parsing JSON graciosamente',
      () async {
        // Arrange: respuesta con JSON inválido
        final mockClient = MockClient((request) async {
          return http.Response('{ invalid json', 200);
        });

        final service = WeatherService(client: mockClient);

        // Act
        final result = await service.getCurrentWeather('Test');

        // Assert: debe usar fallback cuando falla el parsing
        expect(result, isNotNull);
        expect(result.location, isNotNull);
      },
    );
  });
}
