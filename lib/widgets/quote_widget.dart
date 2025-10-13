import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';

class QuoteWidget extends ConsumerWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteAsync = ref.watch(quoteProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: quoteAsync.when(
          data: (quote) => _buildQuoteContent(context, quote),
          loading: () => _buildLoading(),
          error: (err, stack) => _buildError(),
        ),
      ),
    );
  }

  Widget _buildQuoteContent(BuildContext context, quote) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.format_quote,
              color: AppTheme.accentCyan,
              size: isDesktop ? 36 : 28,
            ),
            SizedBox(width: isDesktop ? 16 : 12),
            Text(
              'Daily Quote',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isDesktop ? 24 : 20,
                  ),
            ),
          ],
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        Center(
          child: Text(
            quote.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: isDesktop ? 20 : 16,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                  color: AppTheme.glowWhite,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: isDesktop ? 20 : 12),
        Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '— ${quote.author}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accentBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: isDesktop ? 18 : 16,
                      ),
                ),
                Text(
                  quote.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentCyan.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                )
              ],
            )),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text(
        'Unable to load quote',
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
