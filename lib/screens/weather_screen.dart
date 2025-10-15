import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/system_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final forecastAsync = ref.watch(weatherForecastProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppTheme.darkBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.deepBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.glowWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Weather',
          style: TextStyle(
            color: AppTheme.glowWhite,
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Weather Section
            weatherAsync.when(
              data: (weather) {
                if (weather == null) {
                  return _buildErrorCard('Unable to load weather', isDesktop);
                }
                return _buildCurrentWeather(context, weather, isDesktop);
              },
              loading: () => _buildLoadingCard(isDesktop),
              error: (err, stack) =>
                  _buildErrorCard('Error loading weather', isDesktop),
            ),
            SizedBox(height: isDesktop ? 32 : 24),

            // Forecast Section
            forecastAsync.when(
              data: (forecast) {
                if (forecast == null || forecast.dailyForecasts.isEmpty) {
                  return _buildErrorCard('Unable to load forecast', isDesktop);
                }
                return _buildForecast(context, forecast, isDesktop);
              },
              loading: () => _buildLoadingCard(isDesktop),
              error: (err, stack) =>
                  _buildErrorCard('Error loading forecast', isDesktop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather(
      BuildContext context, WeatherData weather, bool isDesktop) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 32 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Weather',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: isDesktop ? 28 : 22,
                                  color: AppTheme.glowWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.description,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.accentCyan,
                                  fontSize: isDesktop ? 18 : 16,
                                ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _getWeatherIcon(weather.condition),
                  color: AppTheme.accentCyan,
                  size: isDesktop ? 80 : 60,
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 32 : 24),

            // Temperature Display
            Center(
              child: Column(
                children: [
                  Text(
                    '${weather.temperature.round()}°',
                    style: TextStyle(
                      fontSize: isDesktop ? 96 : 72,
                      color: AppTheme.glowWhite,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                  if (weather.feelsLike != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Feels like ${weather.feelsLike!.round()}°',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: isDesktop ? 20 : 16,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: isDesktop ? 40 : 32),

            // Weather Details Grid
            _buildDetailsGrid(context, weather, isDesktop),

            // Sunrise/Sunset if available
            if (weather.sunrise != null && weather.sunset != null) ...[
              SizedBox(height: isDesktop ? 32 : 24),
              _buildSunriseSunset(context, weather, isDesktop),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(
      BuildContext context, WeatherData weather, bool isDesktop) {
    // Collect all available details
    final List<Widget> detailCards = [
      _buildDetailCard(
        context,
        Icons.water_drop,
        '${weather.humidity}%',
        'Humidity',
        isDesktop,
      ),
      _buildDetailCard(
        context,
        Icons.air,
        '${weather.windSpeed.toStringAsFixed(1)} m/s',
        'Wind Speed',
        isDesktop,
      ),
      if (weather.pressure != null)
        _buildDetailCard(
          context,
          Icons.speed,
          '${weather.pressure} hPa',
          'Pressure',
          isDesktop,
        ),
      if (weather.visibility != null)
        _buildDetailCard(
          context,
          Icons.visibility,
          '${(weather.visibility! / 1000).toStringAsFixed(1)} km',
          'Visibility',
          isDesktop,
        ),
      if (weather.clouds != null)
        _buildDetailCard(
          context,
          Icons.cloud,
          '${weather.clouds}%',
          'Cloudiness',
          isDesktop,
        ),
    ];

    // Build grid with 2 columns
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: isDesktop ? 16.0 : 12.0,
        runSpacing: isDesktop ? 16.0 : 12.0,
        children: detailCards,
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, IconData icon, String value,
      String label, bool isDesktop) {
    // Fixed width for cards to ensure 2-column layout
    final cardWidth = isDesktop ? 160.0 : 140.0;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: AppTheme.darkPurple.withAlpha(85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppTheme.accentBlue,
            size: isDesktop ? 36 : 28,
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.glowWhite,
                  fontSize: isDesktop ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isDesktop ? 4 : 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: isDesktop ? 14 : 12,
                  color: AppTheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSunriseSunset(
      BuildContext context, WeatherData weather, bool isDesktop) {
    final timeFormat = DateFormat('HH:mm');

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: AppTheme.darkPurple.withAlpha(85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSunTime(
            context,
            Icons.wb_sunny,
            'Sunrise',
            timeFormat.format(weather.sunrise!),
            isDesktop,
          ),
          Container(
            width: 1,
            height: isDesktop ? 60 : 50,
            color: AppTheme.textSecondary.withAlpha(51),
          ),
          _buildSunTime(
            context,
            Icons.nights_stay,
            'Sunset',
            timeFormat.format(weather.sunset!),
            isDesktop,
          ),
        ],
      ),
    );
  }

  Widget _buildSunTime(BuildContext context, IconData icon, String label,
      String time, bool isDesktop) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.accentCyan,
          size: isDesktop ? 40 : 32,
        ),
        SizedBox(height: isDesktop ? 12 : 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: isDesktop ? 16 : 14,
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: isDesktop ? 22 : 18,
                color: AppTheme.glowWhite,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildForecast(
      BuildContext context, WeatherForecast forecast, bool isDesktop) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 32 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5-Day Forecast',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: isDesktop ? 28 : 22,
                    color: AppTheme.glowWhite,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: isDesktop ? 24 : 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: forecast.dailyForecasts.length,
              separatorBuilder: (context, index) => Divider(
                height: isDesktop ? 32 : 24,
                color: AppTheme.textSecondary.withAlpha(51),
              ),
              itemBuilder: (context, index) {
                final day = forecast.dailyForecasts[index];
                return _buildForecastDay(context, day, isDesktop, index == 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastDay(
      BuildContext context, ForecastDay day, bool isDesktop, bool isToday) {
    final dateFormat = DateFormat('EEEE, MMM d');
    final dayLabel = isToday ? 'Today' : dateFormat.format(day.date);

    return Row(
      children: [
        // Date and Icon
        Expanded(
          child: Row(
            children: [
              Icon(
                _getWeatherIcon(day.condition),
                color: AppTheme.accentCyan,
                size: isDesktop ? 40 : 32,
              ),
              SizedBox(width: isDesktop ? 16 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isDesktop ? 18 : 16,
                            color: AppTheme.glowWhite,
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: isDesktop ? 14 : 12,
                            color: AppTheme.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 12),

        // Temperature Range
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${day.tempMax.round()}°',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isDesktop ? 22 : 18,
                    color: AppTheme.glowWhite,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(width: isDesktop ? 12 : 8),
            Text(
              '${day.tempMin.round()}°',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: isDesktop ? 18 : 16,
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingCard(bool isDesktop) {
    return Card(
      child: Container(
        height: isDesktop ? 300 : 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard(String message, bool isDesktop) {
    return Card(
      child: Container(
        height: isDesktop ? 200 : 150,
        alignment: Alignment.center,
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
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
