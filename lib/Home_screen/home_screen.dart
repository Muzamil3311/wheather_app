import 'package:flutter/material.dart';
import 'package:wheather_app/Model/weather_services/Weather_Services.dart';
import 'package:wheather_app/Model/weather_model.dart';
import 'package:wheather_app/Widgets/weather_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices weatherServices = WeatherServices();
  final TextEditingController controller = TextEditingController();
  bool _isLoading = false;
  Weather? _weather;

  // Fetch weather based on city name
  void getWeather() async {
    FocusScope.of(context).unfocus(); // Close keyboard

    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final weather = await weatherServices.fetchWeather(controller.text.trim());
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather: $e')),
      );
    }
  }

  // Set gradient background based on weather description
  LinearGradient _getBackgroundGradient() {
    if (_weather == null) {
      return const LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    final desc = _weather!.description.toLowerCase();

    if (desc.contains('rain')) {
      return const LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('cloud')) {
      return const LinearGradient(
        colors: [Colors.blueGrey, Colors.grey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('clear') || desc.contains('sun')) {
      return const LinearGradient(
        colors: [Colors.orangeAccent, Colors.yellow],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: _getBackgroundGradient()),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => getWeather(),
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: getWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Get Weather'),
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_weather != null)
                WeatherCard(weather: _weather!),
            ],
          ),
        ),
      ),
    );
  }
}
