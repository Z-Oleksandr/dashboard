# Dashboard Application

A cross-platform personal dashboard built with Flutter and Dart, featuring real-time server monitoring, weather information, daily quotes, and system status indicators.

## Features

-   **Weather Widget**: Real-time weather information with temperature, conditions, humidity, and wind speed
-   **Server Monitoring**: Real-time CPU and Network usage gauges via WebSocket connection
-   **LED Status Indicators**: Visual indicators for system status (Main Server, Main Base, Mobile Base, etc.)
-   **Daily Quote**: Motivational and wisdom quotes updated daily
-   **Latest Note**: Display of most recent note (placeholder for backend integration)
-   **Responsive Design**: Works on Web, iOS, Android, and Windows in both portrait and landscape modes
-   **Dark Theme**: Beautiful dark theme with deep blue/purple color scheme

## Prerequisites

-   Flutter SDK (3.0.0 or higher)
-   Dart SDK (3.0.0 or higher)
-   For development: VS Code or Android Studio
-   OpenWeatherMap API key (free tier available)

## Installation

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd dashboard
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure API Keys and Server Settings

Edit `lib/config/app_config.dart`:

```dart
// Replace with your server IP address
static const String systemMonitorHost = '192.168.1.100'; // Your server IP

// Get a free API key from https://openweathermap.org/api
static const String weatherApiKey = 'YOUR_API_KEY_HERE';

// Update your location coordinates if needed
static const double defaultLat = 52.5200;  // Your latitude
static const double defaultLon = 13.4050;  // Your longitude
```

### 4. Run the application

#### For Web:

```bash
flutter run -d chrome
```

#### For Windows:

```bash
flutter run -d windows
```

#### For Android:

```bash
flutter run -d android
```

#### For iOS:

```bash
flutter run -d ios
```

## Project Structure

```
lib/
├── config/
│   └── app_config.dart          # Configuration and constants
├── models/
│   └── system_models.dart       # Data models
├── providers/
│   └── dashboard_providers.dart # Riverpod state management
├── screens/
│   └── home_screen.dart         # Main dashboard screen
├── services/
│   ├── system_monitor_service.dart  # WebSocket service
│   ├── weather_service.dart         # Weather API service
│   └── quote_service.dart           # Quote API service
├── theme/
│   └── app_theme.dart           # App theme configuration
├── widgets/
│   ├── weather_widget.dart      # Weather display widget
│   ├── quote_widget.dart        # Daily quote widget
│   ├── note_widget.dart         # Latest note widget
│   ├── led_indicators_widget.dart   # Status LED indicators
│   └── server_gauges_widget.dart    # CPU/Network gauges
└── main.dart                    # Application entry point
```

## WebSocket Data Format

The application expects the following JSON structures from your Rust backend:

### SystemData (data_type: 0)

```json
{
    "data_type": 0,
    "num_cpus": 8,
    "num_disks": 2,
    "disks_space": [500000000000, 1000000000000],
    "init_ram_total": 16000000000
}
```

### SystemInfo (data_type: 2)

```json
{
    "data_type": 2,
    "system_name": "Linux",
    "kernel_version": "5.15.0",
    "cpu_arch": "x86_64",
    "os_version": "Ubuntu 22.04",
    "host_name": "server-01",
    "uptime": 86400,
    "docker": "20.10.12"
}
```

### SystemStats (data_type: 1) - Streamed continuously

```json
{
    "data_type": 1,
    "cpu_usage": [25.5, 30.2, 28.1, 22.7],
    "ram_total": 16000000000,
    "ram_used": 8000000000,
    "disks_used_space": [250000000000, 500000000000],
    "network_received": 1024000000,
    "network_transmitted": 2048000000,
    "uptime": 86400
}
```

## Building for Production

### Web

```bash
flutter build web --release
```

### Windows

```bash
flutter build windows --release
```

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Customization

### Colors

Edit `lib/theme/app_theme.dart` to customize the color scheme:

```dart
static const Color darkBlue = Color(0xFF0A1929);
static const Color accentCyan = Color(0xFF4DD0E1);
// etc.
```

### System Indicators

Edit `lib/config/app_config.dart` to change indicator labels:

```dart
static const List<String> systemIndicators = [
  'Main Server',
  'Main Base',
  'Mobile Base',
  'Custom System 1',
  'Custom System 2',
];
```

### Update Intervals

Adjust refresh rates in `lib/config/app_config.dart`:

```dart
static const Duration weatherUpdateInterval = Duration(minutes: 10);
static const Duration quoteUpdateInterval = Duration(hours: 24);
```

## Troubleshooting

### WebSocket Connection Issues

-   Ensure your Rust backend is running on port 8999
-   Check firewall settings
-   Verify the `systemMonitorHost` in `app_config.dart` is correct
-   For web builds, ensure CORS is configured on your backend

### Weather Not Loading

-   Verify your OpenWeatherMap API key is valid
-   Check internet connectivity
-   Ensure latitude and longitude are correct

### Build Errors

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## Future Enhancements

-   Authentication system
-   Notes backend integration
-   Additional server monitoring pages (RAM, Disk, detailed stats)
-   Router information integration
-   Custom widget configuration
-   Dark/Light theme toggle
-   Multiple location weather support

## License

MIT License
