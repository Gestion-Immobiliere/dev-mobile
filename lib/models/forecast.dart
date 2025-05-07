import 'package:intl/intl.dart';

class Forecast {
  final DateTime date;
  final double temperature;
  final String condition;
  final String iconCode;

  Forecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.iconCode,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
    );
  }
}