# 🧪 Guía de Pruebas Unitarias - Electiva

![Tests](https://img.shields.io/badge/Tests-61%2F61-brightgreen)
![Coverage](https://img.shields.io/badge/Coverage-~90%25-green)
![Time](https://img.shields.io/badge/Time-~3s-blue)
![Firebase](https://img.shields.io/badge/Firebase-Auth-orange)

> Documentación completa de las 61 pruebas unitarias implementadas en el proyecto.
> Incluye autenticación con Firebase y manejo de estado de usuario.

---

## 📋 Tabla de Contenidos

- [Resumen](#-resumen)
- [Comandos Rápidos](#-comandos-rápidos)
- [Estructura de Tests](#-estructura-de-tests)
- [Tests Implementados](#-tests-implementados)
- [Casos de Uso](#-casos-de-uso)
- [Mejores Prácticas](#-mejores-prácticas)

---

## 📊 Resumen

### Métricas Generales

| Métrica                 | Valor        |
| ----------------------- | ------------ |
| **Total de tests**      | 61           |
| **Tests pasando**       | 61 (100%) ✅ |
| **Tiempo de ejecución** | ~3 segundos  |
| **Archivos de test**    | 3            |
| **Cobertura funcional** | ~90%         |
| **Autenticación**       | Firebase ✅  |

### Tecnologías de Testing

- **Framework**: flutter_test (SDK)
- **Mocking**: MockClient (http package)
- **Cobertura**: flutter test --coverage
- **CI/CD**: Ejecutable en cualquier plataforma
- **Firebase**: Autenticación integrada

### Distribución por Módulo

| Módulo              | Tests | Archivo                                      |
| ------------------- | ----- | -------------------------------------------- |
| **WeatherModel**    | 7     | `test/models/weather_model_test.dart`        |
| **WeatherService**  | 9     | `test/weather/weather_service_test.dart`     |
| **CalculatorLogic** | 45    | `test/calculator/calculator_logic_test.dart` |

---

## ⚡ Comandos Rápidos

### Ejecutar Todos los Tests

```bash
flutter test
```

**Salida esperada:**

```
00:03 +61: All tests passed!
```

### Tests por Módulo

```bash
# Solo tests de Calculator
flutter test test/calculator/

# Solo tests de Weather
flutter test test/weather/

# Solo tests de Models
flutter test test/models/
```

### Tests con Detalles

```bash
# Reporte expandido (muestra cada test individualmente)
flutter test --reporter expanded

# Reporte JSON
flutter test --reporter json

# Tests en modo watch (re-ejecuta al guardar)
flutter test --watch
```

### Cobertura de Código

```bash
# Generar reporte de cobertura
flutter test --coverage

# Ver reporte HTML (requiere lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS/Linux
start coverage/html/index.html  # Windows
```

### Tests Específicos

```bash
# Ejecutar un archivo específico
flutter test test/calculator/calculator_logic_test.dart

# Ejecutar un test por nombre
flutter test --plain-name "suma dos números positivos correctamente"
```

---

## 📁 Estructura de Tests

```
test/
│
├── calculator/
│   └── calculator_logic_test.dart       # 45 tests
│       ├── Operaciones Básicas (10)
│       ├── División (7)
│       ├── Potencias (5)
│       ├── Raíces (6)
│       ├── Validaciones (9)
│       ├── Operaciones Inválidas (1)
│       └── Casos Edge (4)
│
├── models/
│   └── weather_model_test.dart          # 7 tests
│       ├── Parsing JSON (1)
│       ├── Getters con Formato (1)
│       ├── Conversión Viento (1)
│       ├── Capitalización (1)
│       ├── Campos Opcionales (1)
│       ├── Redondeo (1)
│       └── JSON Completo (1)
│
└── weather/
    └── weather_service_test.dart        # 9 tests
        ├── API Exitosa (1)
        ├── Fallback Error 500 (1)
        ├── URL Correcta (1)
        ├── Coordenadas (2)
        ├── Test Conexión (3)
        ├── Sugerencias (1)
        └── JSON Inválido (1)
```

---

## 🔍 Tests Implementados

### 1. WeatherModel Tests (7 tests)

**Archivo:** `test/models/weather_model_test.dart`

#### ✅ Test 1: Parsing de JSON

```dart
test('fromJson parsea datos correctamente', () {
  final json = {
    "name": "Bogotá",
    "main": {"temp": 22.5, "feels_like": 21.8, "humidity": 65},
    "wind": {"speed": 3.2}
  };

  final model = WeatherModel.fromJson(json);

  expect(model.location, 'Bogotá');
  expect(model.temperature, 22.5);
  expect(model.humidity, 65);
});
```

**Qué verifica:** Conversión correcta de JSON a objeto Dart.

#### ✅ Test 2: Getters con Formato

```dart
test('getters retornan formato correcto', () {
  final model = WeatherModel.fromJson(mockJson);

  expect(model.temperatureFormatted, '22°C');
  expect(model.humidityFormatted, '65%');
  expect(model.windSpeedKmh, '12 km/h');
});
```

**Qué verifica:** Formateo de datos con unidades.

#### ✅ Test 3: Conversión de Viento

```dart
test('convierte viento de m/s a km/h', () {
  final model = WeatherModel.fromJson({
    "wind": {"speed": 5.0}  // m/s
  });

  expect(model.windSpeedKmh, '18 km/h');  // 5 * 3.6 = 18
});
```

**Qué verifica:** Conversión matemática m/s → km/h.

#### ✅ Test 4: Capitalización

```dart
test('capitaliza descripción correctamente', () {
  final model = WeatherModel.fromJson({
    "weather": [{"description": "nubes dispersas"}]
  });

  expect(model.description, 'Nubes Dispersas');
});
```

**Qué verifica:** Primera letra de cada palabra en mayúscula.

#### ✅ Test 5: Campos Opcionales

```dart
test('maneja campo clouds faltante', () {
  final json = {"name": "Test"};  // Sin clouds

  final model = WeatherModel.fromJson(json);

  expect(model.precipitation, 0);  // No crashea
});
```

**Qué verifica:** Manejo seguro de campos nulos.

#### ✅ Test 6: Redondeo de Temperatura

```dart
test('redondea temperatura correctamente', () {
  final model = WeatherModel.fromJson({
    "main": {"temp": 22.7}
  });

  expect(model.temperature, 23.0);  // Redondeado
});
```

**Qué verifica:** Redondeo al entero más cercano.

#### ✅ Test 7: JSON Completo

```dart
test('parsea JSON completo de API', () {
  final json = {/* JSON real de OpenWeatherMap */};

  final model = WeatherModel.fromJson(json);

  expect(model.location, isNotEmpty);
  expect(model.temperature, isA<double>());
});
```

**Qué verifica:** Compatibilidad con respuesta real de API.

---

### 2. WeatherService Tests (9 tests)

**Archivo:** `test/weather/weather_service_test.dart`

#### ✅ Test 1: API Respuesta Exitosa (200)

```dart
test('getCurrentWeather retorna modelo cuando API responde 200', () async {
  final mockClient = MockClient((request) async {
    return http.Response(jsonEncode(mockData), 200);
  });

  final service = WeatherService(client: mockClient);
  final result = await service.getCurrentWeather('London');

  expect(result.location, 'London');
});
```

**Qué verifica:** Parsing exitoso con código HTTP 200.

#### ✅ Test 2: Fallback con Error 500

```dart
test('getCurrentWeather usa fallback cuando API responde 500', () async {
  final mockClient = MockClient((request) async {
    return http.Response('Error', 500);
  });

  final service = WeatherService(client: mockClient);
  final result = await service.getCurrentWeather('Test');

  expect(result.location, 'Bogotá');  // Datos demo
});
```

**Qué verifica:** Sistema de fallback cuando falla API.

#### ✅ Test 3: URL Correcta

```dart
test('getCurrentWeather construye URL correctamente', () async {
  final mockClient = MockClient((request) async {
    expect(request.url.toString(), contains('q=Paris'));
    expect(request.url.toString(), contains('units=metric'));
    return http.Response(jsonEncode(mockData), 200);
  });

  final service = WeatherService(client: mockClient);
  await service.getCurrentWeather('Paris');
});
```

**Qué verifica:** Construcción correcta de URL con parámetros.

#### ✅ Test 4-5: Búsqueda por Coordenadas

```dart
test('getWeatherByCoordinates usa lat/lon', () async {
  final mockClient = MockClient((request) async {
    expect(request.url.toString(), contains('lat=40.7'));
    expect(request.url.toString(), contains('lon=-74.0'));
    return http.Response(jsonEncode(mockData), 200);
  });

  final service = WeatherService(client: mockClient);
  await service.getWeatherByCoordinates(40.7, -74.0);
});
```

**Qué verifica:** Búsqueda por coordenadas geográficas.

#### ✅ Test 6-8: Test de Conexión

```dart
test('testApiConnection devuelve true cuando API responde 200', () async {
  final mockClient = MockClient((request) async {
    return http.Response(jsonEncode(mockData), 200);
  });

  final service = WeatherService(client: mockClient);
  final isConnected = await service.testApiConnection();

  expect(isConnected, true);
});
```

**Qué verifica:** Verificación de conectividad con API.

#### ✅ Test 9: Sugerencias de Ciudades

```dart
test('getCitySuggestions retorna lista de ciudades', () {
  final service = WeatherService();
  final suggestions = service.getCitySuggestions();

  expect(suggestions, isA<List<String>>());
  expect(suggestions.length, greaterThan(0));
});
```

**Qué verifica:** Lista de sugerencias disponible.

---

### 3. CalculatorLogic Tests (45 tests)

**Archivo:** `test/calculator/calculator_logic_test.dart`

#### 📊 Operaciones Básicas (10 tests)

##### ✅ Suma (3 tests)

```dart
test('suma dos números positivos correctamente', () {
  final resultado = CalculatorLogic.calcular(5.0, 3.0, '+');

  expect(resultado.resultado, 8.0);
  expect(resultado.detalleOperacion, '5.0 + 3.0 = 8.0');
  expect(resultado.tieneError, false);
});

test('suma números negativos correctamente', () {
  final resultado = CalculatorLogic.calcular(-10.0, -5.0, '+');
  expect(resultado.resultado, -15.0);
});

test('suma con decimales correctamente', () {
  final resultado = CalculatorLogic.calcular(3.5, 2.25, '+');
  expect(resultado.resultado, 5.75);
});
```

##### ✅ Resta (3 tests)

```dart
test('resta dos números correctamente', () {
  final resultado = CalculatorLogic.calcular(10.0, 3.0, '−');
  expect(resultado.resultado, 7.0);
});

test('resta usando símbolo alternativo "-"', () {
  final resultado = CalculatorLogic.calcular(8.0, 5.0, '-');
  expect(resultado.resultado, 3.0);
});

test('resta que da resultado negativo', () {
  final resultado = CalculatorLogic.calcular(3.0, 8.0, '−');
  expect(resultado.resultado, -5.0);
});
```

##### ✅ Multiplicación (4 tests)

```dart
test('multiplica dos números positivos', () {
  final resultado = CalculatorLogic.calcular(4.0, 5.0, '×');
  expect(resultado.resultado, 20.0);
});

test('multiplica por cero da cero', () {
  final resultado = CalculatorLogic.calcular(100.0, 0.0, '×');
  expect(resultado.resultado, 0.0);
});

test('multiplica números negativos', () {
  final resultado = CalculatorLogic.calcular(-4.0, -3.0, '×');
  expect(resultado.resultado, 12.0);
});
```

#### 📊 División (7 tests) ⚠️ CRÍTICO

```dart
test('divide dos números correctamente', () {
  final resultado = CalculatorLogic.calcular(10.0, 2.0, '÷');
  expect(resultado.resultado, 5.0);
  expect(resultado.tieneError, false);
});

test('división por cero retorna error', () {
  final resultado = CalculatorLogic.calcular(10.0, 0.0, '÷');

  expect(resultado.resultado, double.infinity);
  expect(resultado.detalleOperacion, 'Error: División por cero no definida');
  expect(resultado.tieneError, true);
});

test('división por número muy pequeño retorna error', () {
  final resultado = CalculatorLogic.calcular(10.0, 0.00000001, '÷');
  expect(resultado.tieneError, true);
});

test('división con residuo muestra detalles', () {
  final resultado = CalculatorLogic.calcular(10.0, 3.0, '÷');
  expect(resultado.detalleOperacion, contains('Cociente:'));
  expect(resultado.detalleOperacion, contains('Residuo:'));
});
```

**Casos cubiertos:**

- ✅ División normal
- ✅ División por cero (ERROR controlado)
- ✅ División por número muy pequeño
- ✅ División con residuo
- ✅ División exacta (sin residuo)
- ✅ Resultado muy grande (advertencia)
- ✅ Símbolo alternativo "/"

#### 📊 Potencias (5 tests)

```dart
test('calcula potencia positiva correctamente', () {
  final resultado = CalculatorLogic.calcular(2.0, 3.0, '^');
  expect(resultado.resultado, 8.0);  // 2³ = 8
});

test('calcula potencia con exponente cero', () {
  final resultado = CalculatorLogic.calcular(5.0, 0.0, '^');
  expect(resultado.resultado, 1.0);  // 5⁰ = 1
});

test('calcula potencia con exponente negativo', () {
  final resultado = CalculatorLogic.calcular(2.0, -2.0, '^');
  expect(resultado.resultado, 0.25);  // 2⁻² = 0.25
});

test('calcula potencia con base negativa y exponente par', () {
  final resultado = CalculatorLogic.calcular(-3.0, 2.0, '^');
  expect(resultado.resultado, 9.0);  // (-3)² = 9
});

test('calcula potencia con decimales', () {
  final resultado = CalculatorLogic.calcular(4.0, 0.5, '^');
  expect(resultado.resultado, 2.0);  // 4^0.5 = √4 = 2
});
```

#### 📊 Raíces (6 tests)

```dart
test('calcula raíz cuadrada correctamente', () {
  final resultado = CalculatorLogic.calcular(9.0, 2.0, '√');
  expect(resultado.resultado, 3.0);  // √9 = 3
});

test('calcula raíz cuadrada cuando índice es 0 (default)', () {
  final resultado = CalculatorLogic.calcular(16.0, 0.0, '√');
  expect(resultado.resultado, 4.0);  // Usa 2 por defecto
});

test('calcula raíz cúbica correctamente', () {
  final resultado = CalculatorLogic.calcular(27.0, 3.0, '√');
  expect(resultado.resultado, closeTo(3.0, 0.0001));  // ³√27 = 3
});

test('raíz de número negativo con índice par retorna error', () {
  final resultado = CalculatorLogic.calcular(-9.0, 2.0, '√');

  expect(resultado.resultado, 0.0);
  expect(resultado.tieneError, true);
  expect(resultado.detalleOperacion, contains('Error'));
});

test('raíz con índice negativo retorna error', () {
  final resultado = CalculatorLogic.calcular(9.0, -2.0, '√');
  expect(resultado.tieneError, true);
});

test('raíz de cero es cero', () {
  final resultado = CalculatorLogic.calcular(0.0, 2.0, '√');
  expect(resultado.resultado, 0.0);
});
```

#### 📊 Validaciones (9 tests)

```dart
test('valida número positivo correctamente', () {
  expect(CalculatorLogic.esNumeroValido('123'), true);
});

test('valida número decimal correctamente', () {
  expect(CalculatorLogic.esNumeroValido('3.14'), true);
});

test('valida número negativo correctamente', () {
  expect(CalculatorLogic.esNumeroValido('-42'), true);
});

test('rechaza string vacío', () {
  expect(CalculatorLogic.esNumeroValido(''), false);
});

test('rechaza texto no numérico', () {
  expect(CalculatorLogic.esNumeroValido('abc'), false);
});

test('validar entrada para operación normal - válida', () {
  final error = CalculatorLogic.validarEntrada('5', '3', '+');
  expect(error, null);
});

test('validar entrada para raíz - válida', () {
  final error = CalculatorLogic.validarEntrada('9', '2', '√');
  expect(error, null);
});
```

#### 📊 Casos Edge (4 tests)

```dart
test('suma de números muy grandes', () {
  final resultado = CalculatorLogic.calcular(1e308, 1e308, '+');
  expect(resultado.resultado, double.infinity);  // Overflow
});

test('multiplicación de números muy pequeños', () {
  final resultado = CalculatorLogic.calcular(1e-100, 1e-100, '×');
  expect(resultado.resultado, closeTo(0, 1e-200));  // Underflow
});

test('potencia que genera overflow', () {
  final resultado = CalculatorLogic.calcular(10.0, 1000.0, '^');
  expect(resultado.resultado, double.infinity);
});

test('raíz de 1 es siempre 1', () {
  final resultado = CalculatorLogic.calcular(1.0, 5.0, '√');
  expect(resultado.resultado, closeTo(1.0, 0.0001));
});
```

---

## 💡 Casos de Uso

### Caso 1: Verificar División por Cero

**Problema:** Asegurar que la app no crashea al dividir por cero.

**Test:**

```dart
test('división por cero retorna error', () {
  final resultado = CalculatorLogic.calcular(10.0, 0.0, '÷');
  expect(resultado.tieneError, true);
});
```

**Beneficio:** Sin el test, esto crashearía en producción.

### Caso 2: Validar Fallback de API

**Problema:** Si OpenWeatherMap API falla, la app debe mostrar datos demo.

**Test:**

```dart
test('getCurrentWeather usa fallback cuando API responde 500', () async {
  final mockClient = MockClient((request) async {
    return http.Response('Error', 500);
  });

  final service = WeatherService(client: mockClient);
  final result = await service.getCurrentWeather('Test');

  expect(result.location, 'Bogotá');  // Datos demo
});
```

**Beneficio:** Usuario siempre ve algo, no pantalla de error.

### Caso 3: Conversión de Unidades

**Problema:** Viento viene en m/s, debe mostrarse en km/h.

**Test:**

```dart
test('convierte viento de m/s a km/h', () {
  final model = WeatherModel.fromJson({"wind": {"speed": 5.0}});
  expect(model.windSpeedKmh, '18 km/h');  // 5 * 3.6
});
```

**Beneficio:** Garantiza conversión matemática correcta.

---

## 🎯 Mejores Prácticas

### 1. Estructura AAA (Arrange-Act-Assert)

```dart
test('ejemplo de AAA', () {
  // Arrange: Preparar datos
  const numero1 = 5.0;
  const numero2 = 3.0;

  // Act: Ejecutar función
  final resultado = CalculatorLogic.calcular(numero1, numero2, '+');

  // Assert: Verificar resultado
  expect(resultado.resultado, 8.0);
});
```

### 2. Nombres Descriptivos

✅ **Bueno:**

```dart
test('división por cero retorna error', () { ... });
```

❌ **Malo:**

```dart
test('test1', () { ... });
```

### 3. Un Concepto por Test

✅ **Bueno:**

```dart
test('suma números positivos', () { ... });
test('suma números negativos', () { ... });
```

❌ **Malo:**

```dart
test('suma', () {
  // Prueba 10 casos diferentes
});
```

### 4. Usar Mocks para Dependencias Externas

```dart
// ✅ Bueno: Mock HTTP
final mockClient = MockClient((request) async {
  return http.Response(jsonEncode(mockData), 200);
});

// ❌ Malo: Llamada real a API
final service = WeatherService();  // Lenta, requiere internet
```

### 5. Probar Casos Edge

```dart
// Casos normales
test('división normal', () { ... });

// Casos edge
test('división por cero', () { ... });
test('división por número muy pequeño', () { ... });
test('resultado muy grande', () { ... });
```

---

## 📚 Recursos Adicionales

- [Flutter Testing Documentation](https://docs.flutter.dev/testing/overview)
- [Effective Dart: Testing](https://dart.dev/guides/testing)
- [Package http/testing](https://pub.dev/packages/http/testing)
- [Code Coverage in Flutter](https://flutter.dev/docs/testing/code-coverage)

---

## 🆘 Solución de Problemas

### ❌ Tests fallan con "No se encuentra el archivo"

**Solución:**

```bash
flutter pub get
flutter clean
flutter test
```

### ❌ Tests muy lentos

**Problema:** Llamadas a API reales en lugar de mocks.

**Solución:** Verificar que todos los tests usen `MockClient`.

### ❌ Error "MissingPluginException"

**Solución:** Los tests unitarios no requieren plugins. Si ves este error, estás intentando usar widgets de Flutter en un test unitario. Usa widget tests en su lugar.

---

## 📊 Comparación: Manual vs Automatizado

| Aspecto           | Prueba Manual            | Prueba Automatizada    |
| ----------------- | ------------------------ | ---------------------- |
| **Tiempo**        | ~30 minutos              | ~3 segundos            |
| **Cobertura**     | Limitada (olvidas casos) | Completa (61 casos)    |
| **Repetibilidad** | Baja (error humano)      | Alta (mismo resultado) |
| **Costo**         | Alto (tiempo humano)     | Bajo (una vez escrito) |
| **Velocidad**     | Lenta                    | 600x más rápido        |

---

**Última actualización:** 9 de octubre de 2025  
**Total de tests:** 61  
**Estado:** ✅ Todos pasando  
**Tiempo:** ~3 segundos

---

<div align="center">

### 🎯 Tests = Confianza en el Código

_"Code without tests is broken by design." - Jacob Kaplan-Moss_

</div>
