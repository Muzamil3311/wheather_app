class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windspeed;
  final int sunrise;
  final int sunset;

  // Named constructor
  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windspeed,
    required this.sunrise,
    required this.sunset,
  });

  // Factory constructor to create a Weather instance from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      description: json['weather'][0]['description'] ?? 'No description',
      humidity: json['main']['humidity'] ?? 0,
      windspeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
    );
  }

}
