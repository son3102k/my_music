import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class VolumeNotifier extends ChangeNotifier {
  double _volume = 50.0; // range 0-100

  double get volume => _volume;

  VolumeNotifier() {
    // listen for external changes (hardware buttons, etc.)
    VolumeController.instance.addListener((v) {
      _volume = (v * 100).clamp(0.0, 100.0);
      notifyListeners();
    });
    // initialize current value
    VolumeController.instance.getVolume().then((v) {
      _volume = (v * 100).clamp(0.0, 100.0);
      notifyListeners();
    });
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 100.0);
    VolumeController.instance.setVolume(_volume / 100);
    notifyListeners();
  }
}
