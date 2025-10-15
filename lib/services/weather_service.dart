import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/system_models.dart';
import '../utils/log.dart';

class WeatherService {
  Future<WeatherData?> getCurrentWeather() async {
    try {
      final url = Uri.parse(
        '${AppConfig.weatherApiUrl}/weather?lat=${AppConfig.defaultLat}&lon=${AppConfig.defaultLon}&units=metric&appid=${AppConfig.weatherApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(data);
      } else {
        log.e('Weather API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error fetching weather: $e');
      return null;
    }
  }

  Future<WeatherForecast?> getWeatherForecast() async {
    try {
      final url = Uri.parse(
        '${AppConfig.weatherApiUrl}/forecast?lat=${AppConfig.defaultLat}&lon=${AppConfig.defaultLon}&units=metric&appid=${AppConfig.weatherApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherForecast.fromJson(data);
      } else {
        log.e('Weather Forecast API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log.e('Error fetching weather forecast: $e');
      return null;
    }
  }
}
