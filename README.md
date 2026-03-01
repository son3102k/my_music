# my_music

This repository contains a simple Flutter music player demo.
The app now includes a **Spotify‑style player screen** along with a
lightweight theming system.

## Structure

- `lib/theme` - contains a `ThemeNotifier` providing a dynamic `ThemeData`.
- `lib/screens` - screen widgets including `HomeScreen` (main library) and
  `PlayerScreen` (detailed player).
- `lib/widgets` - reusable UI pieces such as `AlbumArt`, `TrackInfo`, and
  `PlaybackControls`.

You can change the seed color with the palette icon on the player screen and switch between dark/light modes with the sun/moon button; all widgets automatically repaint with the new color scheme.

### Main screen

The home screen now mimics Spotify’s layout with a dark theme and
horizontal "carousel" sections. Each section (Favorites, Songs, Playlists)
displays cards with album art you can scroll through. Tapping a card starts
playback, showing a mini player bar with a draggable progress indicator along
the bottom; you can scrub by dragging just like Spotify’s mini player. Tapping
the bar expands into the full player.

To run the app:

```bash
flutter pub get
flutter run
```

Feel free to replace the placeholder asset at `assets/album_placeholder.png`
with real album art or a network image.
A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
