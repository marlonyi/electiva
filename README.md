# 📱 Electiva - Aplicación Flutter Educativa

![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue)
![Dart](https://img.shields.io/badge/Dart-3.7.2-blue)
![Tests](https://img.shields.io/badge/Tests-61%2F61-brightgreen)
![Coverage](https://img.shields.io/badge/Coverage-~90%25-green)

> Aplicación móvil multiplataforma desarrollada con Flutter que integra funcionalidades de clima en tiempo real y calculadora científica.

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Tecnologías](#️-tecnologías)
- [Instalación](#-instalación)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Módulos](#-módulos)
- [Pruebas Unitarias](#-pruebas-unitarias)
- [API Utilizada](#-api-utilizada)
- [Contribución](#-contribución)
- [Autor](#-autor)

---

## ✨ Características

### 🔐 Autenticación con Firebase

- ✅ Login con email y contraseña
- ✅ Registro de nuevos usuarios
- ✅ Google Sign-In integrado
- ✅ Restablecer contraseña por email
- ✅ Verificación de email automática
- ✅ Estado de autenticación persistente
- ✅ Logout seguro

### 🌤️ Módulo Weather (Clima)

- ✅ Consulta clima en tiempo real por ciudad
- ✅ Búsqueda por coordenadas geográficas
- ✅ Información detallada: temperatura, humedad, viento
- ✅ Iconos dinámicos según condiciones climáticas
- ✅ Sugerencias de ciudades
- ✅ Sistema de fallback si falla la API
- ✅ Conversión automática de unidades (m/s → km/h)

### 🧮 Módulo Calculator (Calculadora)

- ✅ Operaciones básicas: suma, resta, multiplicación, división
- ✅ Operaciones avanzadas: potencias, raíces n-ésimas
- ✅ Validación de entrada robusta
- ✅ Manejo de errores matemáticos (división por cero)
- ✅ Interfaz responsive (móvil, tablet, desktop)
- ✅ Resultados con formato detallado

### 🧪 Testing

- ✅ **61 pruebas unitarias** implementadas
- ✅ Cobertura funcional ~90%
- ✅ Tests automáticos en 3 segundos
- ✅ Mocking de servicios externos
- ✅ Validación de casos edge

---

## 🛠️ Tecnologías

### Framework & Lenguaje

- **Flutter** 3.7.2 - Framework UI multiplataforma
- **Dart** 3.7.2 - Lenguaje de programación

### Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.1 # Llamadas HTTP a API externa
  firebase_core: ^3.6.0 # Core Firebase
  firebase_auth: ^5.3.1 # Autenticación Firebase
  google_sign_in: ^6.2.1 # Google Sign-In

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### API Externa

- **OpenWeatherMap API** - Datos meteorológicos en tiempo real
- Endpoint: `https://api.openweathermap.org/data/2.5/weather`
- Unidades: Métricas (°C, m/s)

### Servicios Firebase

- **Firebase Authentication** - Gestión de usuarios y autenticación
- **Google Sign-In** - Autenticación con cuentas Google
- Características: Email/password, Google OAuth, email verification

---

## 🚀 Instalación

### Requisitos Previos

- Flutter SDK 3.7.2 o superior
- Dart SDK 3.7.2 o superior
- Android Studio / VS Code
- Emulador Android/iOS o dispositivo físico
- **Cuenta de Google para Firebase Console**

### Pasos

1. **Clonar el repositorio**

```bash
git clone https://github.com/marlonyi/electiva.git
cd electiva
```

2. **Instalar dependencias**

```bash
flutter pub get
```

3. **Configurar Firebase**

   #### a. Crear proyecto en Firebase Console

   1. Ve a [Firebase Console](https://console.firebase.google.com/)
   2. Crea un nuevo proyecto
   3. Habilita Authentication

   #### b. Configurar Authentication

   1. Ve a Authentication > Sign-in method
   2. Habilita Email/Password y Google
   3. Para Google: configura OAuth consent screen

   #### c. Obtener configuración del proyecto

   1. Ve a Project settings > General
   2. En "Your apps", agrega una app web
   3. Copia la configuración (apiKey, appId, etc.)

   #### d. Actualizar firebase_options.dart

   Edita `lib/firebase_options.dart` y reemplaza los valores:

   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'tu-api-key-real',
     appId: 'tu-app-id-real',
     messagingSenderId: 'tu-messaging-sender-id-real',
     projectId: 'tu-project-id-real',
     authDomain: 'tu-project-id-real.firebaseapp.com',
     storageBucket: 'tu-project-id-real.appspot.com',
     measurementId: 'tu-measurement-id-real',
   );
   ```

4. **Configurar API del Clima**

   Crea un archivo `.env` en la raíz:

   ```env
   OPENWEATHER_API_KEY=tu-api-key-de-openweathermap
   ```

5. **Verificar configuración de Flutter**

```bash
flutter doctor
```

6. **Ejecutar la aplicación**

```bash
# En modo debug
flutter run

# En modo release
flutter run --release
```

7. **Ejecutar tests**

```bash
flutter test
```

---

## 📁 Estructura del Proyecto

```
electiva/
│
├── lib/                          # Código fuente de la aplicación
│   ├── main.dart                 # Punto de entrada con Firebase init
│   ├── firebase_options.dart     # Configuración Firebase
│   │
│   ├── auth/                     # 🔐 Autenticación Firebase
│   │   └── auth_service.dart
│   │
│   ├── screens/                  # Pantallas de UI
│   │   └── login_screen.dart
│   │
│   ├── home/                     # Pantalla principal
│   │   ├── home_page.dart
│   │   └── home_view.dart
│   │
│   ├── calculator/               # Módulo Calculadora
│   │   ├── calculator_page.dart
│   │   ├── calculator_view.dart
│   │   └── calculator_logic.dart # Lógica de negocio (testeable)
│   │
│   ├── weather/                  # Módulo Clima
│   │   ├── weather_page.dart
│   │   ├── weather_view.dart
│   │   └── weather_service.dart  # Servicio API
│   │
│   ├── models/                   # Modelos de datos
│   │   └── weather_model.dart
│   │
│   └── utils/                    # Utilidades
│       └── responsive_helper.dart
│
├── test/                         # Pruebas unitarias
│   ├── calculator/
│   │   └── calculator_logic_test.dart   # 45 tests
│   ├── models/
│   │   └── weather_model_test.dart      # 7 tests
│   └── weather/
│       └── weather_service_test.dart    # 9 tests
│
├── android/                      # Configuración Android
├── ios/                          # Configuración iOS
├── web/                          # Configuración Web
│
├── pubspec.yaml                  # Dependencias del proyecto
├── README.md                     # Este archivo
└── TESTING.md                    # Guía de pruebas unitarias
```

---

## 🧩 Módulos

### 1. Home (Inicio)

**Ubicación:** `lib/home/`

Pantalla principal con navegación a los módulos Weather y Calculator.

### 2. Weather (Clima)

**Ubicación:** `lib/weather/` y `lib/models/`

Consulta clima en tiempo real usando OpenWeatherMap API.

**Ejemplo de uso:**

```dart
final service = WeatherService();
final weather = await service.getCurrentWeather('Bogotá');

print(weather.temperature);        // 22.5
print(weather.temperatureFormatted); // "22°C"
print(weather.windSpeedKmh);        // "12 km/h"
```

### 3. Calculator (Calculadora)

**Ubicación:** `lib/calculator/`

Calculadora científica con operaciones básicas y avanzadas.

**Operaciones soportadas:**

- ➕ Suma, ➖ Resta, ✖️ Multiplicación, ➗ División
- 🔢 Potencias (x^y), √ Raíces n-ésimas

**Ejemplo de uso:**

```dart
// Suma
final result = CalculatorLogic.calcular(5.0, 3.0, '+');
print(result.resultado);           // 8.0

// División por cero (manejo de error)
final error = CalculatorLogic.calcular(10.0, 0.0, '÷');
print(error.tieneError);           // true
```

---

## 🧪 Pruebas Unitarias

El proyecto incluye **61 pruebas unitarias** con cobertura ~90%.

### Resumen de Tests

| Módulo          | Tests  | Cobertura |
| --------------- | ------ | --------- |
| WeatherModel    | 7      | 100%      |
| WeatherService  | 9      | 95%       |
| CalculatorLogic | 45     | 100%      |
| **TOTAL**       | **61** | **~90%**  |

### Ejecutar Tests

```bash
# Todos los tests
flutter test

# Tests de un módulo específico
flutter test test/calculator/
flutter test test/weather/

# Con reporte detallado
flutter test --reporter expanded
```

**Resultado esperado:**

```
00:03 +61: All tests passed!
```

### Más información

Ver [TESTING.md](./TESTING.md) para guía completa de testing.

---

## 🌐 API Utilizada

### OpenWeatherMap API

**Base URL:** `https://api.openweathermap.org/data/2.5/weather`

**Ejemplo de Request:**

```
GET https://api.openweathermap.org/data/2.5/weather?q=Bogotá&appid=API_KEY&units=metric
```

**Ejemplo de Response:**

```json
{
  "name": "Bogotá",
  "main": {
    "temp": 22.5,
    "humidity": 65
  },
  "wind": {
    "speed": 3.2
  },
  "weather": [
    {
      "description": "nubes dispersas"
    }
  ]
}
```

---

## 🎯 Características Destacadas

### Arquitectura Limpia

```
UI Layer (Widgets)
    ↓
Business Logic Layer (calculator_logic.dart, weather_service.dart)
    ↓
Data Layer (weather_model.dart, HTTP)
```

### Manejo de Errores

- ✅ División por cero controlada
- ✅ Fallback si API falla
- ✅ Validación de entrada
- ✅ JSON inválido manejado graciosamente

### Responsive Design

- ✅ Móvil, tablet, desktop
- ✅ Layouts adaptativos
- ✅ Tamaños de fuente dinámicos

---

## 🤝 Contribución

Este es un proyecto educativo. Si deseas contribuir:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## 👨‍💻 Autor

**Marlon Yi**

- GitHub: [@marlonyi](https://github.com/marlonyi)
- Repositorio: [electiva](https://github.com/marlonyi/electiva)

---

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

---

**Versión:** 1.0.0  
**Última actualización:** 9 de octubre de 2025  
**Estado:** ✅ Producción

---

<div align="center">
  
### ⭐ Si te gusta este proyecto, dale una estrella en GitHub

Made with ❤️ using Flutter

</div>
