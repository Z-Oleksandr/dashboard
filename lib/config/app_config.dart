class AppConfig {
  // System Monitor WebSocket
  static const String systemMonitorHost =
      '192.168.0.116'; // Change to your server IP
  static const int systemMonitorPort = 8999;
  static const String systemMonitorWsUrl =
      'ws://$systemMonitorHost:$systemMonitorPort';

  // Weather API (OpenWeatherMap - get free API key from openweathermap.org)
  static const String weatherApiKey = '51fc421d696e1d573f9afca11f5a6618';
  static const String weatherApiUrl = 'https://api.openweathermap.org/data/2.5';

  // Quote API (using quotable.io - free, no API key needed)

  // Currently down, but would be better to  use
  // static const String quoteApiUrl =
  //     'https://api.quotable.io/quotes/random?tags=inspirational|wisdom|motivational';

  // Currently available
  static const String quoteApiUrl = 'https://api.api-ninjas.com/v1/quotes';
  static const String quoteApiKey = 'r8uU7WZDUfdeMjL6mQ+Ocw==B7Zxirtp8PTxc8aw';

  // Default location (Dresden, Germany)
  static const double defaultLat = 51.046649;
  static const double defaultLon = 13.765539;

  // Update intervals
  static const Duration weatherUpdateInterval = Duration(minutes: 10);
  static const Duration quoteUpdateInterval = Duration(hours: 24);

  // System status indicators
  static const List<String> systemIndicators = [
    'Main Server',
    'Main Base',
    'Mobile Base',
    'System 4',
    'System 5',
  ];
}
