import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Model/weather_model.dart';

class WeatherCard extends StatefulWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    setState(() => _visible = true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getAnimationPath(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('rain')) {
      return 'assets/animations/rain.json';
    } else if (desc.contains('cloud')) {
      return 'assets/animations/cloudy.json';
    } else if (desc.contains('snow')) {
      return 'assets/animations/snowfall.json';
    } else if (desc.contains('clear') || desc.contains('sun')) {
      return 'assets/animations/sunny.json';
    } else {
      return 'assets/animations/cloudy.json'; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final animationPath = _getAnimationPath(widget.weather.description);

    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Card(
          margin: const EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          color: Colors.white.withOpacity(0.9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Lottie.asset(
                  animationPath,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.weather.cityName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${widget.weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  widget.weather.description,
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoTile('Humidity', '${widget.weather.humidity}%'),
                    _buildInfoTile('Wind', '${widget.weather.windspeed} m/s'),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
