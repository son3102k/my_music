import 'package:flutter/material.dart';

/// Shows the title and artist of the current track.
class TrackInfo extends StatelessWidget {
  final String title;
  final String artist;

  const TrackInfo({Key? key, required this.title, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          artist,
          style: theme.bodyLarge?.copyWith(color: theme.bodyMedium?.color?.withOpacity(0.7)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
