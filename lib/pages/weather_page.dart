import 'package:flutter/material.dart';
import 'package:kalema_meteo/models/weather_model.dart';
import 'package:kalema_meteo/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService("6133381350f7ade38d2e5447424d1376");
  Weather? _weather;
  //fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();
    // get weather for the current city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // if there is an error, set the weather to null
      setState(() {
        _weather = null;
      });

      // handle error
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    // fetch weather when the widget is initialized
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "Loading city..."),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text('${_weather?.temperature.round()} °C'),

            //weather condition
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
