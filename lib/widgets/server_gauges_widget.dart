import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';

class ServerGaugesWidget extends ConsumerWidget {
  const ServerGaugesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(systemStatsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.monitor_heart,
                  color: AppTheme.accentCyan,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Server Resources',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            statsAsync.when(
              data: (stats) => _buildGauges(context, stats),
              loading: () => _buildLoadingGauges(context),
              error: (_, __) => _buildErrorGauges(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGauges(BuildContext context, stats) {
    final cpuUsage = stats.averageCpuUsage;
    final networkMbps = (stats.totalNetwork / 1024).clamp(0.0, 100.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildGauge(
            context,
            'CPU',
            cpuUsage,
            '${cpuUsage.toStringAsFixed(1)}%',
            Icons.memory,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildGauge(
            context,
            'Network',
            networkMbps,
            '${networkMbps.toStringAsFixed(1)} MB/s',
            Icons.network_check,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingGauges(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildGauge(context, 'CPU', 0, '0%', Icons.memory),
        ),
        const SizedBox(width: 24),
        Expanded(
          child:
              _buildGauge(context, 'Network', 0, '0 MB/s', Icons.network_check),
        ),
      ],
    );
  }

  Widget _buildErrorGauges(BuildContext context) {
    return Center(
      child: Text(
        'Unable to connect to server',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.redAccent,
            ),
      ),
    );
  }

  Widget _buildGauge(
    BuildContext context,
    String label,
    double value,
    String valueText,
    IconData icon,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CustomPaint(
            painter: GaugePainter(
              value: value.clamp(0.0, 100.0),
              primaryColor: AppTheme.accentCyan,
              secondaryColor: AppTheme.accentBlue,
              backgroundColor: AppTheme.deepPurple,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppTheme.accentCyan, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    valueText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.glowWhite,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  GaugePainter({
    required this.value,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final strokeWidth = 12.0;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    // Gradient for the value arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi * 0.75,
      endAngle: -math.pi * 0.75 + (math.pi * 1.5 * (value / 100)),
      colors: [
        primaryColor,
        secondaryColor,
        value > 80 ? Colors.orange : secondaryColor,
      ],
    );

    final valuePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw value arc with animation effect
    canvas.drawArc(
      rect,
      -math.pi * 0.75,
      math.pi * 1.5 * (value / 100),
      false,
      valuePaint,
    );

    // Glow effect for high values
    if (value > 0) {
      final glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawArc(
        rect,
        -math.pi * 0.75,
        math.pi * 1.5 * (value / 100),
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
