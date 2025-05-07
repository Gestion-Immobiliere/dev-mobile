import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meteo_senegal/models/forecast.dart';
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=fr'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de charger les données météo');
    }
  }

  Future<List<Forecast>> getForecast(String city) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/forecast?q=$city&appid=$apiKey&units=metric&lang=fr',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['list'] as List)
          .map((item) => Forecast.fromJson(item))
          .toList();
    } else {
      throw Exception('Impossible de charger les prévisions');
    }
  }
}
