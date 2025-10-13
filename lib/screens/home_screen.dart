import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_providers.dart';
import '../widgets/weather_widget.dart';
import '../widgets/quote_widget.dart';
import '../widgets/note_widget.dart';
import '../widgets/led_indicators_widget.dart';
import '../widgets/server_gauges_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        ref.invalidate(weatherProvider);
                      },
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _buildGridLayout(context, orientation),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context, Orientation orientation) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = orientation == Orientation.landscape || screenWidth > 900;

    if (isWide) {
      // Wide layout: 2 columns with better aspect ratio
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: _getAspectRatio(screenWidth),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildListDelegate([
          const WeatherWidget(),
          const ServerGaugesWidget(),
          const QuoteWidget(),
          const LedIndicatorsWidget(),
          const NoteWidget(),
        ]),
      );
    } else {
      // Narrow layout: 1 column
      return SliverList(
        delegate: SliverChildListDelegate([
          const WeatherWidget(),
          const SizedBox(height: 16),
          const ServerGaugesWidget(),
          const SizedBox(height: 16),
          const LedIndicatorsWidget(),
          const SizedBox(height: 16),
          const QuoteWidget(),
          const SizedBox(height: 16),
          const NoteWidget(),
        ]),
      );
    }
  }

  double _getAspectRatio(double screenWidth) {
    if (screenWidth > 1600) return 2.0;
    if (screenWidth > 1200) return 1.6;
    if (screenWidth > 900) return 1.4;
    return 1.3;
  }
}
