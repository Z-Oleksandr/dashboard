import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/app_config.dart';
import '../models/system_models.dart';
import '../utils/log.dart';

class SystemMonitorService {
  WebSocketChannel? _channel;
  final _statsController = StreamController<SystemStats>.broadcast();
  final _dataController = StreamController<SystemData>.broadcast();
  final _infoController = StreamController<SystemInfo>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  bool _isConnected = false;
  Timer? _reconnectTimer;

  Stream<SystemStats> get statsStream => _statsController.stream;
  Stream<SystemData> get dataStream => _dataController.stream;
  Stream<SystemInfo> get infoStream => _infoController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _isConnected;

  void connect() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(AppConfig.systemMonitorWsUrl),
      );

      _isConnected = true;
      _connectionController.add(true);

      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final dataType = data['data_type'] as int?;

      switch (dataType) {
        case 0:
          _dataController.add(SystemData.fromJson(data));
          break;
        case 1:
          _statsController.add(SystemStats.fromJson(data));
          break;
        case 2:
          _infoController.add(SystemInfo.fromJson(data));
          break;
      }
    } catch (e) {
      log.e('Error parsing message: $e');
    }
  }

  void _handleError(dynamic error) {
    log.e('WebSocket error: $error');
    _isConnected = false;
    _connectionController.add(false);
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    log.e('WebSocket disconnected');
    _isConnected = false;
    _connectionController.add(false);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      log.w('Attempting to reconnect...');
      connect();
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _connectionController.add(false);
  }

  void dispose() {
    disconnect();
    _statsController.close();
    _dataController.close();
    _infoController.close();
    _connectionController.close();
  }
}
