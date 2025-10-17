FROM cirrusci/flutter:3.29.3-stable AS builder
ARG OPENWEATHER_API_KEY

WORKDIR /app

# Permitir ejecutar flutter como root dentro del contenedor (evita el warning)
ENV FLUTTER_ALLOW_ROOT=true

# Copiar pubspec y resolver dependencias primero (cache de docker)
COPY pubspec.* /app/
RUN flutter pub get

# Copiar el resto del proyecto
COPY . /app

# Compila la web e incrusta la API key con --dart-define
RUN flutter build web --release --dart-define=OPENWEATHER_API_KEY=$OPENWEATHER_API_KEY

FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]