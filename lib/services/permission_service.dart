import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() {
    return _instance;
  }

  PermissionService._internal();

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    try {
      if (!Platform.isAndroid) {
        return true;
      }

      final status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      print('Error requesting storage permission: $e');
      // If permission handler fails, assume permission is granted
      return true;
    }
  }

  // Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    try {
      if (!Platform.isAndroid) {
        return true;
      }

      final status = await Permission.storage.status;
      return status.isGranted;
    } catch (e) {
      print('Error checking storage permission: $e');
      return true;
    }
  }

  // Request file access permission (for Android 13+)
  Future<bool> requestMediaAudioPermission() async {
    try {
      if (!Platform.isAndroid) {
        return true;
      }

      // For Android 13+ (API 33+), use READ_MEDIA_AUDIO
      final status = await Permission.audio.request();
      return status.isGranted;
    } catch (e) {
      print('Error requesting audio permission: $e');
      return true;
    }
  }

  // Open app settings
  Future<void> openAppSettingsPage() async {
    try {
      await openAppSettings();
    } catch (e) {
      print('Error opening app settings: $e');
    }
  }
}
