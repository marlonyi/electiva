# 🌐 **CONFIGURACIÓN API REAL - OPENWEATHERMAP**

## 🚀 **¡YA ESTÁ LISTA PARA API REAL!**

La aplicación está configurada para usar datos reales de OpenWeatherMap. Solo necesitas tu API key.

---

## 🔑 **OBTENER API KEY GRATUITA (5 minutos)**

### **Paso 1**: Registro

1. Ve a: **https://openweathermap.org/api**
2. Clic en **"Sign Up"** (Registrarse)
3. Completa el formulario:
   - **Username**: Tu nombre de usuario
   - **Email**: Tu email válido
   - **Password**: Contraseña segura
   - **Company**: Puedes poner "Personal" o "Student"
   - **Purpose**: Selecciona "Education" o "Other"

### **Paso 2**: Activación

1. **Confirma tu email** (revisa tu bandeja de entrada)
2. Inicia sesión en OpenWeatherMap
3. Ve a tu perfil → **"API keys"**
4. Copia tu **Default API key** (algo como: `abc123def456ghi789`)

---

## ⚙️ **CONFIGURAR EN TU APLICACIÓN**

### **Abrir archivo**: `lib/weather/weather_service.dart`

### **Reemplazar esta línea**:

```dart
static const String _apiKey = '2c8c4f8b9a3d2e1f6h5g4j7k8l9m0n1p';
```

### **Por tu API key real**:

```dart
static const String _apiKey = 'TU_API_KEY_REAL_AQUI';
```

**Ejemplo**:

```dart
static const String _apiKey = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';
```

---

## ✅ **VERIFICAR QUE FUNCIONA**

1. **Guarda el archivo** después de poner tu API key
2. **Ejecuta la app**: `flutter run`
3. **Busca el indicador**:
   - 🟢 **"API Real Conectada"** = ¡Perfecto!
   - 🟠 **"Modo Demo"** = Verifica tu API key

---

## 🌍 **FUNCIONALIDADES DISPONIBLES**

### **Con API Real obtienes**:

- ✅ **Datos actuales** de cualquier ciudad del mundo
- ✅ **Temperatura real** actualizada cada minuto
- ✅ **Clima en tiempo real** (lluvia, sol, nublado)
- ✅ **Búsqueda global** (Madrid, Tokyo, New York, etc.)
- ✅ **Métricas precisas** (humedad, viento, sensación térmica)

### **Ciudades que puedes probar**:

- 🇨🇴 **Colombia**: Bogotá, Medellín, Cali, Cartagena
- 🌎 **Internacional**: London, Paris, New York, Tokyo, Sydney
- 🏙️ **Cualquier ciudad** del mundo con nombre en inglés

---

## 🔧 **SOLUCIÓN DE PROBLEMAS**

### **🟠 Si aparece "Modo Demo"**:

1. **Verifica la API key** (32 caracteres alfanuméricos)
2. **Espera 10-15 minutos** (las keys nuevas tardan en activarse)
3. **Revisa conexión a internet**
4. **Reinicia la app** después de cambiar la key

### **❌ Si aparece error "API Key inválida"**:

1. **Copia la key completa** sin espacios extra
2. **Confirma tu email** en OpenWeatherMap
3. **Usa la "Default" API key** (no generes una nueva)

### **🌐 Si aparece "Ciudad no encontrada"**:

1. **Usa nombres en inglés**: "Bogota" en lugar de "Bogotá"
2. **Prueba variaciones**: "Medellin", "Cali", "Barranquilla"
3. **Ciudades internacionales**: "London", "Madrid", "Paris"

---

## 🎯 **LÍMITES GRATUITOS (Más que suficiente)**

OpenWeatherMap FREE incluye:

- ✅ **1,000 llamadas/día** (una cada 86 segundos)
- ✅ **60 llamadas/hora**
- ✅ **Datos actuales** de clima
- ✅ **Todas las ciudades** del mundo
- ✅ **Sin límite de tiempo**

Perfect para desarrollo y uso personal! 🎉

---

## 📱 **PRÓXIMOS PASOS OPCIONALES**

Una vez funcione con API real, puedes:

1. **Agregar geolocalización** (ubicación automática)
2. **Pronóstico 5 días** (requiere endpoint diferente)
3. **Mapas del clima** (lluvia, temperatura)
4. **Alertas meteorológicas** (tormentas, etc.)

---

## 🏆 **¡LISTO!**

Ahora tienes una app de clima profesional con datos reales de todo el mundo! 🌍⚡
