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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.power_settings_new,
                  color: AppTheme.accentCyan,
                  size: isDesktop ? 32 : 24,
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Text(
                  'System Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: isDesktop ? 24 : 20,
                      ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 24 : 20),
            connectionAsync.when(
              data: (isConnected) =>
                  _buildIndicators(context, isConnected, isDesktop),
              loading: () => _buildIndicators(context, false, isDesktop),
              error: (_, __) => _buildIndicators(context, false, isDesktop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators(
      BuildContext context, bool isMainServerOnline, bool isDesktop) {
    final crossAxisCount = isDesktop ? 2 : 3;

    return Center(
      child: Wrap(
        spacing: isDesktop ? 20 : 12,
        runSpacing: isDesktop ? 20 : 12,
        alignment: WrapAlignment.center,
        children: List.generate(
          AppConfig.systemIndicators.length,
          (index) => SizedBox(
            width: isDesktop
                ? (MediaQuery.of(context).size.width > 1200 ? 200 : 180)
                : (MediaQuery.of(context).size.width - 80) / 3,
            child: _buildLedIndicator(
              context,
              AppConfig.systemIndicators[index],
              index == 0 ? isMainServerOnline : false,
              isDesktop,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLedIndicator(
      BuildContext context, String label, bool isOnline, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 20 : 12,
        vertical: isDesktop ? 16 : 12,
      ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isDesktop ? 16 : 12,
            height: isDesktop ? 16 : 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? AppTheme.accentCyan : Colors.grey,
              boxShadow: isOnline
                  ? [
                      BoxShadow(
                        color: AppTheme.accentCyan.withOpacity(0.6),
                        blurRadius: isDesktop ? 12 : 8,
                        spreadRadius: isDesktop ? 3 : 2,
                      ),
                    ]
                  : null,
            ),
          ),
          SizedBox(width: isDesktop ? 12 : 8),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        isOnline ? AppTheme.glowWhite : AppTheme.textSecondary,
                    fontSize: isDesktop ? 15 : 13,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
