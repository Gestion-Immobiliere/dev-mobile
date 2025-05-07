class Weather {
  final String city;
  final double temperature;
  final String condition;
  final double windSpeed;
  final int humidity;
  final String iconCode;

  Weather({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.humidity,
    required this.iconCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}
