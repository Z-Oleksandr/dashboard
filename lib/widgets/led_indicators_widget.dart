import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';

class LedIndicatorsWidget extends ConsumerWidget {
  const LedIndicatorsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(systemConnectionProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.power_settings_new,
                  color: AppTheme.accentCyan,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'System Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            connectionAsync.when(
              data: (isConnected) => _buildIndicators(context, isConnected),
              loading: () => _buildIndicators(context, false),
              error: (_, __) => _buildIndicators(context, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators(BuildContext context, bool isMainServerOnline) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        AppConfig.systemIndicators.length,
        (index) => _buildLedIndicator(
          context,
          AppConfig.systemIndicators[index],
          index == 0
              ? isMainServerOnline
              : false, // Only main server shows real status
        ),
      ),
    );
  }

  Widget _buildLedIndicator(BuildContext context, String label, bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.darkPurple.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOnline
              ? AppTheme.accentCyan.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? AppTheme.accentCyan : Colors.grey,
              boxShadow: isOnline
                  ? [
                      BoxShadow(
                        color: AppTheme.accentCyan.withOpacity(0.6),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isOnline ? AppTheme.glowWhite : AppTheme.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
