# CLAUDE.md - Dashboard Project

## Project Overview

This is a cross-platform personal dashboard application built with Flutter/Dart for the frontend and Rust for the backend. The dashboard provides real-time system monitoring, weather information, daily motivational quotes, and system status indicators.

### Technology Stack

-   **Frontend**: Flutter (Dart)
-   **Backend**: Rust
-   **Database**: MariaDB
-   **State Management**: Riverpod
-   **Real-time Communication**: WebSocket
-   **Platforms**: Web, iOS, Android, Windows

## Project Structure

```
dashboard/
├── lib/
│   ├── config/
│   │   └── app_config.dart           # Configuration constants
│   ├── models/
│   │   └── system_models.dart        # Data models
│   ├── providers/
│   │   └── dashboard_providers.dart  # Riverpod providers
│   ├── screens/
│   │   └── home_screen.dart          # Main dashboard screen
│   ├── services/
│   │   ├── system_monitor_service.dart  # WebSocket service
│   │   ├── weather_service.dart         # Weather API
│   │   └── quote_service.dart           # Quote API
│   ├── theme/
│   │   └── app_theme.dart            # App theming
│   ├── widgets/
│   │   ├── weather_widget.dart
│   │   ├── quote_widget.dart
│   │   ├── note_widget.dart
│   │   ├── led_indicators_widget.dart
│   │   └── server_gauges_widget.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

## Design System

### Color Palette

-   **Dark Blue**: `#0A1929` - Main background
-   **Deep Blue**: `#132F4C` - Card background
-   **Dark Purple**: `#1A0B2E` - Accent backgrounds
-   **Deep Purple**: `#2D1B47` - Secondary elements
-   **Accent Cyan**: `#4DD0E1` - Primary accent
-   **Accent Blue**: `#42A5F5` - Secondary accent
-   **Glow White**: `#E3F2FD` - Primary text
-   **Text Primary**: `#ECEFF1` - Body text
-   **Text Secondary**: `#B0BEC5` - Secondary text

### Responsive Breakpoints

-   **Mobile**: < 600px
-   **Desktop**: ≥ 600px
-   **Wide Desktop**: > 900px
-   **Ultra-wide**: > 1200px

## Backend Communication

### WebSocket Connection

-   **Host**: Configurable in `app_config.dart` (default: localhost)
-   **Port**: 8999
-   **Protocol**: WebSocket (ws://)
-   **Authentication**: Currently none (planned for future)

### Message Types

The Rust backend sends three types of messages differentiated by `data_type`:

#### 1. SystemData (data_type: 0)

Initial system information sent once on connection.

```rust
pub struct SystemData {
    data_type: u32,        // Always 0
    num_cpus: usize,
    num_disks: u32,
    disks_space: Vec<u64>,
    init_ram_total: u64,
}
```

#### 2. SystemInfo (data_type: 2)

System metadata sent once on connection.

```rust
pub struct SystemInfo {
    data_type: u32,        // Always 2
    system_name: String,
    kernel_version: String,
    cpu_arch: String,
    os_version: String,
    host_name: String,
    uptime: u64,
    docker: String,
}
```

#### 3. SystemStats (data_type: 1)

Real-time statistics streamed continuously.

```rust
pub struct SystemStats {
    data_type: u32,              // Always 1
    cpu_usage: Vec<f32>,         // Per-core CPU usage %
    ram_total: u64,              // Total RAM in bytes
    ram_used: u64,               // Used RAM in bytes
    disks_used_space: Vec<u64>,  // Used disk space per disk
    network_received: u64,       // Bytes received
    network_transmitted: u64,    // Bytes transmitted
    uptime: u64,                 // System uptime in seconds
}
```

### Auto-reconnection

The WebSocket service implements automatic reconnection with a 5-second delay if the connection is lost.

## External APIs

### Weather API

-   **Service**: OpenWeatherMap
-   **Endpoint**: `https://api.openweathermap.org/data/2.5/weather`
-   **Authentication**: API key required (free tier available)
-   **Update Frequency**: Every 10 minutes
-   **Configuration**: Set API key and coordinates in `app_config.dart`

### Quote API

-   **Service**: Quotable.io
-   **Endpoint**: `https://api.quotable.io/random?tags=inspirational|wisdom|motivational`
-   **Authentication**: None required
-   **Update Frequency**: Once per day
-   **Caching**: Uses SharedPreferences to cache daily quote

## Features

### Current Features

1. **Weather Widget**

    - Current temperature
    - Weather condition and description
    - Humidity percentage
    - Wind speed
    - Weather-appropriate icons

2. **Server Gauges**

    - Animated CPU usage gauge
    - Animated Network usage gauge
    - Gradient fill based on usage
    - Glow effect for active metrics

3. **LED Status Indicators**

    - 6 system status indicators
    - Layout: 2 columns × 3 rows (desktop) / 3 columns × 2 rows (mobile)
    - Glowing cyan LED for active systems
    - Grey LED for inactive systems
    - Only "Main Server" shows real connection status

4. **Daily Quote**

    - Motivational/wisdom quote
    - Author attribution
    - Cached for 24 hours

5. **Latest Note** (Placeholder)
    - Title display
    - Preview text
    - Timestamp
    - Ready for backend integration

### Planned Features

-   Authentication system
-   Notes backend integration
-   Full server monitoring page (RAM, Disk details)
-   Router information integration
-   Multiple location weather support
-   Dark/Light theme toggle
-   Custom widget configuration
-   User preferences

## Configuration

### Required Setup

1. **System Monitor Backend**

    ```dart
    // lib/config/app_config.dart
    static const String systemMonitorHost = 'YOUR_SERVER_IP';
    static const int systemMonitorPort = 8999;
    ```

2. **Weather API**

    ```dart
    // Get free API key from https://openweathermap.org/api
    static const String weatherApiKey = 'YOUR_API_KEY';
    static const double defaultLat = 52.5200;  // Your latitude
    static const double defaultLon = 13.4050;  // Your longitude
    ```

3. **System Indicators**
    ```dart
    static const List<String> systemIndicators = [
      'Main Server',
      'Main Base',
      'Mobile Base',
      'System 4',
      'System 5',
      'System 6',
    ];
    ```

## State Management

### Riverpod Providers

**Services**

-   `systemMonitorServiceProvider` - WebSocket service singleton
-   `weatherServiceProvider` - Weather API service
-   `quoteServiceProvider` - Quote API service

**Streams**

-   `systemStatsProvider` - Real-time system statistics
-   `systemDataProvider` - Initial system data
-   `systemInfoProvider` - System metadata
-   `systemConnectionProvider` - Connection status

**Futures**

-   `weatherProvider` - Weather data
-   `quoteProvider` - Daily quote

**Static**

-   `noteProvider` - Note data (currently dummy)

## Responsive Design

### Mobile (< 600px)

-   Single column layout
-   Compact spacing (16-20px padding)
-   Smaller fonts and icons
-   3 columns for LED indicators
-   Gauge size: 140px

### Desktop (≥ 600px)

-   Two column grid layout
-   Generous spacing (24-32px padding)
-   Larger fonts and icons
-   2 columns for LED indicators
-   Gauge size: 180px

### Dynamic Aspect Ratios

-   Ultra-wide (>1600px): 2.0
-   Wide (>1200px): 1.6
-   Desktop (>900px): 1.4
-   Default: 1.3

## Development Guidelines

### Adding a New Widget

1. Create widget file in `lib/widgets/`
2. Implement responsive sizing (check `screenWidth > 600`)
3. Use `mainAxisSize: MainAxisSize.min` for Columns in Cards
4. Follow the color scheme from `app_theme.dart`
5. Add to home_screen.dart layout

### Adding a New Data Source

1. Create model in `system_models.dart`
2. Create service in `lib/services/`
3. Create provider in `dashboard_providers.dart`
4. Consume in widget using `ref.watch()`

### Styling Conventions

-   Use Theme.of(context) for colors and text styles
-   Responsive padding: `EdgeInsets.all(isDesktop ? 24 : 20)`
-   Responsive font sizes: `fontSize: isDesktop ? 20 : 16`
-   Card radius: 16px
-   Border radius for containers: 12px
-   Shadow: `elevation: 4`

## Performance Considerations

-   WebSocket streams use `broadcast()` for multiple listeners
-   Weather data cached for 10 minutes
-   Quote cached for 24 hours using SharedPreferences, but currently still loads new on page reload
-   Gauges use CustomPainter for efficient rendering
-   Auto-reconnection prevents memory leaks

## Security Notes

-   No authentication currently implemented
-   WebSocket connection is unencrypted (ws://)
-   Weather API key exposed in code
-   **TODO**: Implement proper authentication
-   **TODO**: Use secure WebSocket (wss://)
-   **TODO**: Environment variables for secrets

## Future Backend Integration

### Notes Feature

When implementing the notes backend:

1. Update `noteProvider` from static to `FutureProvider`
2. Create `NotesService` in `lib/services/`
3. Add API endpoint configuration
4. Implement CRUD operations
5. Add refresh mechanism
