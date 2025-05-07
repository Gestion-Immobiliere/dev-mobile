import 'package:flutter/material.dart';
import 'package:meteo_senegal/services/weather_service.dart';
import 'weather_screen.dart';

class SearchScreen extends StatefulWidget {
  final WeatherService weatherService;

  const SearchScreen({Key? key, required this.weatherService})
    : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Météo Sénégal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Entrez une ville du Sénégal',
                  hintText: 'Ex: Dakar, Thiès, Saint-Louis...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une ville';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => WeatherScreen(
                              city: _cityController.text,
                              weatherService: widget.weatherService,
                            ),
                      ),
                    );
                  }
                },
                child: const Text('Rechercher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
