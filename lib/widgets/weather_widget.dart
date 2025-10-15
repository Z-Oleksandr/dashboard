import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_providers.dart';
import '../screens/weather_screen.dart';
import '../theme/app_theme.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const WeatherScreen(),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: weatherAsync.when(
            data: (weather) {
              if (weather == null) {
                return _buildError('Unable to load weather');
              }
              return _buildWeatherContent(context, weather);
            },
            loading: () => _buildLoading(),
            error: (err, stack) => _buildError('Error loading weather'),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent(BuildContext context, weather) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weather',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isDesktop ? 24 : 20,
                  ),
            ),
            Icon(
              _getWeatherIcon(weather.condition),
              color: AppTheme.accentCyan,
              size: isDesktop ? 48 : 32,
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 32 : 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${weather.temperature.round()}°',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: isDesktop ? 72 : 56,
                    color: AppTheme.glowWhite,
                  ),
            ),
            SizedBox(width: isDesktop ? 32 : 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.condition,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.accentCyan,
                          fontSize: isDesktop ? 22 : 18,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: isDesktop ? 16 : 14,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 24 : 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildWeatherDetail(
                context,
                Icons.water_drop,
                '${weather.humidity}%',
                'Humidity',
                isDesktop,
              ),
            ),
            SizedBox(width: isDesktop ? 24 : 16),
            Expanded(
              child: _buildWeatherDetail(
                context,
                Icons.air,
                '${weather.windSpeed.toStringAsFixed(1)} m/s',
                'Wind',
                isDesktop,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    bool isDesktop,
  ) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 12),
      decoration: BoxDecoration(
        color: AppTheme.darkPurple.withAlpha(85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppTheme.accentBlue,
            size: isDesktop ? 32 : 24,
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.glowWhite,
                  fontSize: isDesktop ? 20 : 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: isDesktop ? 4 : 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: isDesktop ? 14 : 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }
}
