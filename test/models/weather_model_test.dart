import 'package:flutter_test/flutter_test.dart';
import 'package:electiva/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('fromJson parsea correctamente todos los campos', () {
      // Arrange: preparar datos de prueba (simulando respuesta de la API)
      final json = {
        "name": "Bogotá",
        "main": {"temp": 22.5, "feels_like": 24.2, "humidity": 65},
        "wind": {"speed": 3.2},
        "clouds": {"all": 40},
        "weather": [
          {"description": "nubes dispersas"},
        ],
      };

      // Act: ejecutar la función a probar
      final model = WeatherModel.fromJson(json);

      // Assert: verificar que los valores se parsearon correctamente
      expect(model.location, 'Bogotá');
      expect(model.temperature, 22.5);
      expect(model.feelsLike, 24.2);
      expect(model.humidity, 65);
      expect(model.windSpeed, 3.2);
      expect(model.precipitation, 40);
      expect(model.description.toLowerCase(), contains('nubes'));
    });

    test('getters devuelven formato correcto con unidades', () {
      // Arrange
      final json = {
        "name": "London",
        "main": {"temp": 15.7, "feels_like": 14.3, "humidity": 70},
        "wind": {"speed": 5.0},
        "clouds": {"all": 20},
        "weather": [
          {"description": "clear sky"},
        ],
      };

      // Act
      final model = WeatherModel.fromJson(json);

      // Assert: verificar formato con unidades
      expect(model.temperatureCelsius, '16°C'); // redondeado de 15.7
      expect(model.feelsLikeCelsius, '14°C'); // redondeado de 14.3
      expect(model.humidityPercent, '70%');
      expect(model.precipitationPercent, '20%');

      // Verificar conversión de viento: 5.0 m/s * 3.6 = 18 km/h
      expect(model.windSpeedKmh, '18 km/h');
    });

    test('conversión de viento de m/s a km/h funciona correctamente', () {
      // Arrange: varios valores de prueba
      final testCases = [
        {'speed': 3.2, 'expected': '12 km/h'}, // 3.2 * 3.6 ≈ 11.52 → 12
        {'speed': 5.0, 'expected': '18 km/h'}, // 5.0 * 3.6 = 18.0
        {'speed': 0.0, 'expected': '0 km/h'}, // caso límite
        {'speed': 10.5, 'expected': '38 km/h'}, // 10.5 * 3.6 = 37.8 → 38
      ];

      for (var testCase in testCases) {
        final json = {
          "name": "Test",
          "main": {"temp": 20.0, "feels_like": 19.0, "humidity": 50},
          "wind": {"speed": testCase['speed']},
          "clouds": {"all": 10},
          "weather": [
            {"description": "test"},
          ],
        };

        // Act
        final model = WeatherModel.fromJson(json);

        // Assert
        expect(
          model.windSpeedKmh,
          testCase['expected'],
          reason: 'Failed for wind speed ${testCase['speed']} m/s',
        );
      }
    });

    test('capitalizedDescription capitaliza correctamente', () {
      // Arrange
      final json = {
        "name": "Test",
        "main": {"temp": 20.0, "feels_like": 19.0, "humidity": 50},
        "wind": {"speed": 2.0},
        "clouds": {"all": 10},
        "weather": [
          {"description": "nubes dispersas", "icon": "02d"},
        ],
      };

      // Act
      final model = WeatherModel.fromJson(json);

      // Assert: cada palabra debe estar capitalizada
      expect(model.capitalizedDescription, 'Nubes Dispersas');
      expect(model.capitalizedDescription[0], 'N'); // primera letra mayúscula
    });

    test('maneja campo clouds faltante con valor por defecto', () {
      // Arrange: JSON sin el campo clouds (usa ?? 0 en fromJson)
      final jsonSinClouds = {
        "name": "Test City",
        "main": {"temp": 20.0, "feels_like": 19.0, "humidity": 50},
        "wind": {"speed": 2.0},
        // clouds: null implícitamente
        "weather": [
          {"description": "test weather", "icon": "01d"},
        ],
      };

      // Act
      final model = WeatherModel.fromJson(jsonSinClouds);

      // Assert: debe usar valor por defecto 0
      expect(model.precipitation, 0);
      expect(model.precipitationPercent, '0%');
    });

    test('redondeo de temperaturas funciona correctamente', () {
      // Arrange: temperaturas con decimales
      final testCases = [
        {'temp': 15.4, 'expected': '15°C'},
        {'temp': 15.5, 'expected': '16°C'}, // redondeo hacia arriba
        {'temp': 15.6, 'expected': '16°C'},
        {'temp': -2.3, 'expected': '-2°C'},
        {'temp': -2.7, 'expected': '-3°C'},
        {'temp': 0.0, 'expected': '0°C'},
      ];

      for (var testCase in testCases) {
        final json = {
          "name": "Test",
          "main": {
            "temp": testCase['temp'],
            "feels_like": testCase['temp'],
            "humidity": 50,
          },
          "wind": {"speed": 2.0},
          "clouds": {"all": 10},
          "weather": [
            {"description": "test"},
          ],
        };

        // Act
        final model = WeatherModel.fromJson(json);

        // Assert
        expect(
          model.temperatureCelsius,
          testCase['expected'],
          reason: 'Failed for temperature ${testCase['temp']}°C',
        );
      }
    });
  });
}
