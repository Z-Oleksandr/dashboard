class SystemData {
  final int dataType;
  final int numCpus;
  final int numDisks;
  final List<int> disksSpace;
  final int initRamTotal;

  SystemData({
    required this.dataType,
    required this.numCpus,
    required this.numDisks,
    required this.disksSpace,
    required this.initRamTotal,
  });

  factory SystemData.fromJson(Map<String, dynamic> json) {
    return SystemData(
      dataType: json['data_type'] ?? 0,
      numCpus: json['num_cpus'] ?? 0,
      numDisks: json['num_disks'] ?? 0,
      disksSpace: (json['disks_space'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      initRamTotal: json['init_ram_total'] ?? 0,
    );
  }
}

class SystemInfo {
  final int dataType;
  final String systemName;
  final String kernelVersion;
  final String cpuArch;
  final String osVersion;
  final String hostName;
  final int uptime;
  final String docker;

  SystemInfo({
    required this.dataType,
    required this.systemName,
    required this.kernelVersion,
    required this.cpuArch,
    required this.osVersion,
    required this.hostName,
    required this.uptime,
    required this.docker,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      dataType: json['data_type'] ?? 2,
      systemName: json['system_name'] ?? '',
      kernelVersion: json['kernel_version'] ?? '',
      cpuArch: json['cpu_arch'] ?? '',
      osVersion: json['os_version'] ?? '',
      hostName: json['host_name'] ?? '',
      uptime: json['uptime'] ?? 0,
      docker: json['docker'] ?? '',
    );
  }
}

class SystemStats {
  final int dataType;
  final List<double> cpuUsage;
  final int ramTotal;
  final int ramUsed;
  final List<int> disksUsedSpace;
  final int networkReceived;
  final int networkTransmitted;
  final int uptime;

  SystemStats({
    required this.dataType,
    required this.cpuUsage,
    required this.ramTotal,
    required this.ramUsed,
    required this.disksUsedSpace,
    required this.networkReceived,
    required this.networkTransmitted,
    required this.uptime,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      dataType: json['data_type'] ?? 1,
      cpuUsage: (json['cpu_usage'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      ramTotal: json['ram_total'] ?? 0,
      ramUsed: json['ram_used'] ?? 0,
      disksUsedSpace: (json['disks_used_space'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      networkReceived: json['network_received'] ?? 0,
      networkTransmitted: json['network_transmitted'] ?? 0,
      uptime: json['uptime'] ?? 0,
    );
  }

  double get averageCpuUsage {
    if (cpuUsage.isEmpty) return 0.0;
    return cpuUsage.reduce((a, b) => a + b) / cpuUsage.length;
  }

  double get ramUsagePercent {
    if (ramTotal == 0) return 0.0;
    return (ramUsed / ramTotal) * 100;
  }

  int get totalNetwork => networkReceived + networkTransmitted;
}

class WeatherData {
  final double temperature;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final double? feelsLike;
  final int? pressure;
  final int? visibility;
  final int? clouds;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    this.feelsLike,
    this.pressure,
    this.visibility,
    this.clouds,
    this.sunrise,
    this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      icon: json['weather'][0]['icon'] ?? '01d',
      feelsLike: json['main']['feels_like'] != null
          ? (json['main']['feels_like'] as num).toDouble()
          : null,
      pressure: json['main']['pressure'] as int?,
      visibility: json['visibility'] as int?,
      clouds: json['clouds']?['all'] as int?,
      sunrise: json['sys']?['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['sys']['sunrise'] * 1000)
          : null,
      sunset: json['sys']?['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
          : null,
    );
  }
}

class ForecastDay {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int? clouds;

  ForecastDay({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    this.clouds,
  });
}

class WeatherForecast {
  final List<ForecastDay> dailyForecasts;

  WeatherForecast({required this.dailyForecasts});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'] ?? [];
    if (list.isEmpty) {
      return WeatherForecast(dailyForecasts: []);
    }

    // Group 3-hour forecasts by day
    final Map<String, List<Map<String, dynamic>>> groupedByDay = {};

    for (var item in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch((item['dt'] as int) * 1000);
      final dateKey = '${dt.year}-${dt.month}-${dt.day}';

      if (!groupedByDay.containsKey(dateKey)) {
        groupedByDay[dateKey] = [];
      }
      groupedByDay[dateKey]!.add(item as Map<String, dynamic>);
    }

    // Convert grouped data to daily forecasts
    final List<ForecastDay> dailyForecasts = [];

    groupedByDay.forEach((dateKey, items) {
      if (items.isEmpty) return;

      // Calculate min/max temps for the day
      double tempMin = double.infinity;
      double tempMax = double.negativeInfinity;
      int totalHumidity = 0;
      double totalWindSpeed = 0;
      int? totalClouds = 0;
      int cloudCount = 0;

      // Get the most common weather condition
      Map<String, int> conditionCounts = {};
      String mostCommonCondition = '';
      String mostCommonDescription = '';
      String mostCommonIcon = '';
      int maxConditionCount = 0;

      for (var item in items) {
        final temp = (item['main']['temp'] as num).toDouble();
        if (temp < tempMin) tempMin = temp;
        if (temp > tempMax) tempMax = temp;

        totalHumidity += item['main']['humidity'] as int;
        totalWindSpeed += (item['wind']['speed'] as num).toDouble();

        if (item['clouds'] != null && item['clouds']['all'] != null) {
          totalClouds = (totalClouds ?? 0) + (item['clouds']['all'] as int);
          cloudCount++;
        }

        final condition = item['weather'][0]['main'] as String;
        conditionCounts[condition] = (conditionCounts[condition] ?? 0) + 1;

        if (conditionCounts[condition]! > maxConditionCount) {
          maxConditionCount = conditionCounts[condition]!;
          mostCommonCondition = condition;
          mostCommonDescription = item['weather'][0]['description'] as String;
          mostCommonIcon = item['weather'][0]['icon'] as String;
        }
      }

      final avgHumidity = (totalHumidity / items.length).round();
      final avgWindSpeed = totalWindSpeed / items.length;
      final avgClouds = cloudCount > 0 ? (totalClouds! / cloudCount).round() : null;

      dailyForecasts.add(ForecastDay(
        date: DateTime.fromMillisecondsSinceEpoch((items[0]['dt'] as int) * 1000),
        tempMin: tempMin,
        tempMax: tempMax,
        condition: mostCommonCondition,
        description: mostCommonDescription,
        icon: mostCommonIcon,
        humidity: avgHumidity,
        windSpeed: avgWindSpeed,
        clouds: avgClouds,
      ));
    });

    // Sort by date
    dailyForecasts.sort((a, b) => a.date.compareTo(b.date));

    return WeatherForecast(dailyForecasts: dailyForecasts);
  }
}

class DailyQuote {
  final String content;
  final String author;

  DailyQuote({
    required this.content,
    required this.author,
  });

  factory DailyQuote.fromJson(Map<String, dynamic> json) {
    return DailyQuote(
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
    );
  }
}

class DailyQuoteNinjas {
  final String content;
  final String author;
  final String category;

  DailyQuoteNinjas(
      {required this.content, required this.author, required this.category});

  factory DailyQuoteNinjas.fromJson(Map<dynamic, dynamic> json) {
    return DailyQuoteNinjas(
        content: json['quote'] ?? '',
        author: json['author'] ?? 'Unknown',
        category: json['category'] ?? '');
  }
}

class Note {
  final String title;
  final String preview;
  final DateTime timestamp;

  Note({
    required this.title,
    required this.preview,
    required this.timestamp,
  });
}
