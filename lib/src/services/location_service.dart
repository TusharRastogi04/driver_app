import 'dart:async';
import 'package:geolocator/geolocator.dart';

typedef LocationCallback = void Function(double latitude, double longitude);

class LocationService {
  StreamSubscription<Position>? _positionStream;
  final LocationSettings _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0, // update for every movement
  );

  /// Start tracking driver location
  void startTracking(LocationCallback callback) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      print("Location services are disabled.");
      return;
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    // Start listening to position updates
    _positionStream = Geolocator.getPositionStream(locationSettings: _locationSettings)
        .listen((Position position) {
      callback(position.latitude, position.longitude);
    });
  }

  /// Stop tracking driver location
  void stopTracking() {
    _positionStream?.cancel();
  }
}
