import 'package:flutter/material.dart';

class TrackListItem extends StatefulWidget {
  final int number;
  final String title;
  final String artist;
  final String? album;
  final String duration;
  final String imageUrl;
  final bool isPlaying;
  final bool isLiked;
  final VoidCallback onTap;
  final VoidCallback onLikePressed;
  final VoidCallback? onMorePressed;

  const TrackListItem({
    Key? key,
    required this.number,
    required this.title,
    required this.artist,
    this.album,
    required this.duration,
    required this.imageUrl,
    this.isPlaying = false,
    this.isLiked = false,
    required this.onTap,
    required this.onLikePressed,
    this.onMorePressed,
  }) : super(key: key);

  @override
  State<TrackListItem> createState() => _TrackListItemState();
}

class _TrackListItemState extends State<TrackListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              // Track number or play icon
              SizedBox(
                width: 32,
                child: Center(
                  child: _isHovered || widget.isPlaying
                      ? Icon(
                          widget.isPlaying ? Icons.play_arrow : Icons.play_circle_outline,
                          color: colors.primary,
                          size: 20,
                        )
                      : Text(
                          '${widget.number}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurface.withOpacity(0.5),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Album art
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  widget.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      color: colors.surface,
                      child: Icon(Icons.music_note, color: colors.primary),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Title and artist
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: widget.isPlaying ? colors.primary : colors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Duration
              Text(
                widget.duration,
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(width: 12),
              // Like button
              IconButton(
                icon: Icon(
                  widget.isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: widget.isLiked ? Colors.red : colors.onSurface,
                  size: 20,
                ),
                onPressed: widget.onLikePressed,
                constraints: const BoxConstraints(
                  minHeight: 32,
                  minWidth: 32,
                ),
                padding: EdgeInsets.zero,
              ),
              // More options
              if (widget.onMorePressed != null)
                IconButton(
                  icon: Icon(Icons.more_vert, color: colors.onSurface, size: 20),
                  onPressed: widget.onMorePressed,
                  constraints: const BoxConstraints(
                    minHeight: 32,
                    minWidth: 32,
                  ),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
