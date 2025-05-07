import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatelessWidget {
  final String city;
  final WeatherService weatherService;

  const WeatherScreen({
    Key? key,
    required this.city,
    required this.weatherService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Météo - $city'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WeatherScreen(
                  city: city,
                  weatherService: weatherService,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          weatherService.getWeather(city),
          weatherService.getForecast(city),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(context, snapshot.error.toString());
          } else if (snapshot.hasData) {
            final weather = snapshot.data![0] as Weather;
            final forecasts = snapshot.data![1] as List<Forecast>;
            return RefreshIndicator(
              onRefresh: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherScreen(
                      city: city,
                      weatherService: weatherService,
                    ),
                  ),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildCurrentWeather(weather),
                    _buildForecastList(forecasts),
                  ],
                ),
              ),
            );
          }
          return _buildErrorWidget(context, 'Aucune donnée disponible');
        },
      ),
    );
  }

  Widget _buildCurrentWeather(Weather weather) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${weather.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Text(
            weather.condition,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildWeatherDetail('Vent', '${weather.windSpeed} km/h'),
                  const Divider(),
                  _buildWeatherDetail('Humidité', '${weather.humidity}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastList(List<Forecast> forecasts) {
    // Filtrer pour n'avoir qu'une prévision par jour
    final dailyForecasts = forecasts.where((forecast) {
      return forecast.date.hour == 12; // On prend midi comme référence
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prévisions sur 5 jours',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dailyForecasts.length,
              itemBuilder: (context, index) {
                final forecast = dailyForecasts[index];
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(forecast.date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Image.network(
                            'https://openweathermap.org/img/wn/${forecast.iconCode}.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${forecast.temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            forecast.condition,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WeatherScreen(
                  city: city,
                  weatherService: weatherService,
                ),
              ),
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}