import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';

class NoteWidget extends ConsumerWidget {
  const NoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(noteProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sticky_note_2,
                  color: AppTheme.accentCyan,
                  size: isDesktop ? 32 : 24,
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Text(
                  'Latest Note',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: isDesktop ? 24 : 20,
                      ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 24 : 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  note.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.glowWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 22 : 18,
                      ),
                ),
                SizedBox(height: isDesktop ? 12 : 8),
                Text(
                  note.preview,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: isDesktop ? 16 : 14,
                        height: 1.5,
                      ),
                  maxLines: isDesktop ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 16 : 12),
            Text(
              DateFormat('MMM dd, yyyy • HH:mm').format(note.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentBlue,
                    fontSize: isDesktop ? 14 : 12,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
