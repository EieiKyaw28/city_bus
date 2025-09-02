import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  LocationService._internal();

  factory LocationService() => _instance;

  Future<Position> getCurrentLocation(BuildContext context) async {
    bool shouldNavigateToSearchScreen = false;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          shouldNavigateToSearchScreen = true;
          throw Exception('Location services are disabled.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        openAppSettings();
        throw Exception(
          "Location permissions are permanently denied. Please enable them from settings.",
        );
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      if (shouldNavigateToSearchScreen) {
        if (context.mounted) {
         //TODO page
        }
      }
      rethrow;
    }
  }

  Future<void> openAppSettingsPage() async {
    final opened = await openAppSettings();
    if (!opened) {
      debugPrint("Failed to open app settings");
    }
  }
}
