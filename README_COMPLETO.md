# 🎓 Electiva Móvil - App Educativa

## 📱 Descripción del Proyecto

**Electiva Móvil** es una aplicación educativa desarrollada en **Flutter** que integra múltiples funcionalidades en una experiencia unificada con navegación fluida y diseño profesional.

## 🌟 Características Principales

### 🏠 **Página de Inicio (Home)**

- **Landing Page Profesional** con diseño de gradientes
- **Cards Interactivas** que explican cada funcionalidad
- **Información Tecnológica** sobre el stack utilizado
- **Navegación Rápida** a todas las secciones

### 🧮 **Calculadora Científica**

- **Operaciones Básicas**: Suma, Resta, Multiplicación, División
- **Operaciones Avanzadas**: Potenciación, Radicación
- **Manejo de Errores**: División por cero con diálogos informativos
- **Diseño Compacto**: Teclado estilo calculadora profesional
- **TextEditingController** para entrada de datos numéricos

### 🌤️ **Módulo de Clima**

- **Búsqueda por Ciudad** con autocompletado
- **Datos Meteorológicos Completos**: Temperatura, humedad, viento
- **Interfaz Visual Atractiva** con cards informativas
- **Manejo de Estados**: Loading, error, éxito
- **Simulación de API** (preparado para integración real)

## 🏗️ Arquitectura del Proyecto

### 📂 Estructura Modular

```
lib/
├── main.dart                 # 🚀 Aplicación principal con navegación
├── models/
│   └── weather_model.dart    # 📊 Modelo de datos del clima
├── home/
│   ├── home_page.dart        # 🏠 Wrapper de la página inicio
│   └── home_view.dart        # 🎨 Vista principal con diseño
├── calculator/
│   ├── calculator_page.dart  # 🧮 Wrapper de calculadora
│   └── calculator_view.dart  # 📱 Lógica de calculadora científica
└── weather/
    ├── weather_page.dart     # 🌤️ Wrapper del módulo clima
    ├── weather_view.dart     # 🌍 Interfaz de usuario del clima
    └── weather_service.dart  # 🔧 Servicio de datos meteorológicos
```

## 🎯 Funcionalidades de Navegación

### 📱 **Bottom Navigation Bar**

- **3 Secciones Principales**: Inicio, Calculadora, Clima
- **Animaciones Suaves** en transiciones entre páginas
- **Indicadores Visuales** para la página activa
- **Iconos Profesionales** con Material Design 3

### 🎛️ **Drawer Navigation**

- **Header Gradiente** con branding de la app
- **Lista de Secciones** con iconos y descripciones
- **Información de la App** con diálogo "Acerca de"
- **Diseño Responsive** con contenedores redondeados

### ⚡ **Transiciones Animadas**

- **PageView Controller** para navegación fluida
- **AnimationController** para efectos visuales
- **Transform.scale** para micro-animaciones
- **AnimatedSwitcher** para cambio de títulos

## 🛠️ Tecnologías Utilizadas

### 📱 **Frontend**

- **Flutter** (SDK más reciente)
- **Dart** (Lenguaje de programación)
- **Material Design 3** (Sistema de diseño)

### 📦 **Dependencias**

- **http**: `^1.2.1` (Peticiones API - preparado para uso real)
- **cupertino_icons**: `^1.0.8` (Iconos iOS/Material)

### 🎨 **Diseño**

- **Material 3 Color Scheme** (Paleta azul profesional)
- **Custom Gradients** (Gradientes personalizados)
- **Responsive Layout** (Adaptable a diferentes tamaños)
- **Card-based Design** (Diseño basado en tarjetas)

## 🚀 Funcionalidades Técnicas

### 🧮 **Sistema de Calculadora**

- **Validación de Entrada** (números válidos, campos requeridos)
- **Manejo de Errores Robusto** (división por cero, números inválidos)
- **Operaciones Matemáticas Avanzadas** (potencias, raíces)
- **Interfaz Intuitiva** (teclado visual, campos etiquetados)

### 🌐 **Integración API del Clima**

- **Arquitectura de Servicios** (separación de lógica de datos)
- **Modelos de Datos Estructurados** (parsing JSON, conversiones)
- **Estados de Aplicación** (loading, success, error)
- **Datos de Demostración** (mock data para pruebas)

### 🎭 **Sistema de Navegación**

- **State Management** (StateWul widgets, controladores)
- **Page Controllers** (navegación programática)
- **Animation Controllers** (efectos visuales suaves)
- **Drawer Integration** (menú lateral profesional)

## 📊 Resultados del Proyecto

### ✅ **Objetivos Cumplidos**

1. ✅ **Estructura Modular Completa** - Código organizado y mantenible
2. ✅ **Navegación Fluida** - Drawer + Bottom Navigation + Animaciones
3. ✅ **Calculadora Científica** - Todas las operaciones matemáticas
4. ✅ **Módulo de Clima** - Interfaz completa con API mock
5. ✅ **Diseño Profesional** - Material Design 3, gradientes, cards
6. ✅ **Manejo de Errores** - División por cero, validaciones robustas
7. ✅ **TextEditingController** - Entrada de datos controlada
8. ✅ **Preparación API Real** - Estructura lista para integración

### 📈 **Características Destacadas**

- **Código Limpio**: Estructura modular y comentarios descriptivos
- **UX Profesional**: Animaciones suaves y feedback visual
- **Escalabilidad**: Arquitectura preparada para nuevas funcionalidades
- **Responsividad**: Adaptable a diferentes dispositivos
- **Mantenibilidad**: Separación clara de responsabilidades

## 🎓 **Valor Educativo**

### 📚 **Conceptos Aprendidos**

- **Arquitectura Flutter** (widgets, estados, navegación)
- **Gestión de Estado** (StatefulWidget, controllers)
- **Diseño de Interfaces** (Material Design, layouts)
- **Integración de APIs** (servicios, modelos, manejo async)
- **Validación y Errores** (UX defensivo, feedback usuario)

### 🏆 **Mejores Prácticas Implementadas**

- **Separación de Responsabilidades** (views, services, models)
- **Reutilización de Componentes** (widgets modulares)
- **Manejo de Recursos** (dispose, memory management)
- **Documentación Completa** (comentarios, README)

---

## 🚀 **Instrucciones de Ejecución**

1. **Verificar Flutter**: `flutter doctor`
2. **Instalar Dependencias**: `flutter pub get`
3. **Ejecutar App**: `flutter run`
4. **Seleccionar Plataforma**: Windows/Chrome/Edge

---

## 👨‍💻 **Desarrollo**

**Proyecto Académico** - Electiva de Programación Móvil  
**Tecnología**: Flutter & Dart  
**Arquitectura**: Modular con navegación profesional  
**Estado**: ✅ **Completado y Funcional**

---

_¡Aplicación educativa completa con navegación profesional, calculadora científica y módulo de clima!_ 🎉
