import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'views/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo Sénégal',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchScreen(
        weatherService: WeatherService(
          '78d5801213d4b32e512dbc31fa4f601b',
        ), // Remplacez par votre clé API
      ),
    );
  }
}
