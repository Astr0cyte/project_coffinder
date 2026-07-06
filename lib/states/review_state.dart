import 'package:flutter/material.dart';

/// Feature tags a user can pick when reviewing a place.
enum PlaceFeature {
  airConditioned,
  pets,
  quiet,
  wifi,
  parking,
  friendlyStaff,
}

extension PlaceFeatureLabel on PlaceFeature {
  String get label {
    switch (this) {
      case PlaceFeature.airConditioned:
        return 'Air conditioned';
      case PlaceFeature.pets:
        return 'Pets';
      case PlaceFeature.quiet:
        return 'Quiet';
      case PlaceFeature.wifi:
        return 'Wifi';
      case PlaceFeature.parking:
        return 'Parking';
      case PlaceFeature.friendlyStaff:
        return 'Friendly staff';
    }
  }
}

/// Holds all mutable state for the "Share your visit" review screen.
class ReviewState extends ChangeNotifier {
  int _rating = 0;
  final Set<PlaceFeature> _selectedFeatures = {};
  String _experience = '';

  static const int maxRating = 5;

  int get rating => _rating;
  Set<PlaceFeature> get selectedFeatures =>
      Set.unmodifiable(_selectedFeatures);
  String get experience => _experience;

  /// Require at least a rating before the user can submit.
  bool get canSubmit => _rating > 0;

  void setRating(int value) {
    if (value < 0 || value > maxRating) return;
    _rating = value;
    notifyListeners();
  }

  void toggleFeature(PlaceFeature feature) {
    if (_selectedFeatures.contains(feature)) {
      _selectedFeatures.remove(feature);
    } else {
      _selectedFeatures.add(feature);
    }
    notifyListeners();
  }

  void setExperience(String value) {
    _experience = value;
  }

  void reset() {
    _rating = 0;
    _selectedFeatures.clear();
    _experience = '';
    notifyListeners();
  }
}