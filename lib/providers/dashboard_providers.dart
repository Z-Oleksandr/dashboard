import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/system_models.dart';
import '../services/system_monitor_service.dart';
import '../services/weather_service.dart';
import '../services/quote_service.dart';

// Services
final systemMonitorServiceProvider = Provider<SystemMonitorService>((ref) {
  final service = SystemMonitorService();
  service.connect();
  ref.onDispose(() => service.dispose());
  return service;
});

final weatherServiceProvider =
    Provider<WeatherService>((ref) => WeatherService());
final quoteServiceProvider = Provider<QuoteService>((ref) => QuoteService());

// System Monitor Streams
final systemStatsProvider = StreamProvider<SystemStats>((ref) {
  final service = ref.watch(systemMonitorServiceProvider);
  return service.statsStream;
});

final systemDataProvider = StreamProvider<SystemData>((ref) {
  final service = ref.watch(systemMonitorServiceProvider);
  return service.dataStream;
});

final systemInfoProvider = StreamProvider<SystemInfo>((ref) {
  final service = ref.watch(systemMonitorServiceProvider);
  return service.infoStream;
});

final systemConnectionProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(systemMonitorServiceProvider);
  return Stream.value(service.isConnected);
});

// Weather Provider
final weatherProvider = FutureProvider<WeatherData?>((ref) async {
  final service = ref.watch(weatherServiceProvider);
  return service.getCurrentWeather();
});

// Quote Provider
final quoteProvider = FutureProvider<DailyQuoteNinjas>((ref) async {
  final service = ref.watch(quoteServiceProvider);
  return service.getDailyQuote();
});

// Dummy Note Provider
final noteProvider = Provider<Note>((ref) {
  return Note(
    title: 'Welcome to Dashboard',
    preview: 'This is a placeholder note. Backend integration coming soon...',
    timestamp: DateTime.now(),
  );
});
