class WeatherModel {
  final String location;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final int precipitation;
  final String icon;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.precipitation,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['name'] ?? 'Ubicación desconocida',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      precipitation: json['clouds']['all'] ?? 0,
      icon: json['weather'][0]['icon'] ?? '01d',
    );
  }

  String get temperatureCelsius => '${temperature.round()}°C';
  String get feelsLikeCelsius => '${feelsLike.round()}°C';
  String get windSpeedKmh => '${(windSpeed * 3.6).round()} km/h';
  String get humidityPercent => '$humidity%';
  String get precipitationPercent => '$precipitation%';

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  String get capitalizedDescription {
    return description
        .split(' ')
        .map((word) {
          return word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : word;
        })
        .join(' ');
  }
}
