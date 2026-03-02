import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum MediaCardVariant { album, playlist, artist }

class MediaCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String imageUrl;
  final MediaCardVariant variant;
  final VoidCallback onTap;
  final VoidCallback? onPlayPressed;
  /// Optional size of the square image portion (width and height).
  ///
  /// When null the image will expand to fit its parent constraints.
  final double? imageSize;

  const MediaCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.variant = MediaCardVariant.album,
    required this.onTap,
    this.onPlayPressed,
    this.imageSize,
  }) : super(key: key);

  @override
  State<MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<MediaCard> with AutomaticKeepAliveClientMixin {
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => true;

  Widget _buildImage() {
    final errBuilder = (BuildContext context, Object error, StackTrace? stackTrace) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Icon(Icons.music_note,
            size: 32, color: Theme.of(context).colorScheme.primary),
      );
    };

    if (widget.imageUrl.startsWith('http')) {
      return Image(
        image: CachedNetworkImageProvider(widget.imageUrl),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => errBuilder(context, error, stackTrace),
      );
    } else {
      return Image.asset(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: errBuilder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin
    final isCircle = widget.variant == MediaCardVariant.artist;
    final radius = isCircle ? 9999.0 : 8.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: widget.imageSize,
                      height: widget.imageSize,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _buildImage(),
                      ),
                    ),
                    if (_isHovered && widget.onPlayPressed != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: widget.onPlayPressed,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.play_arrow,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
