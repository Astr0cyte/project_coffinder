import 'package:flutter/material.dart';

/// Holds all data collected across the 4-step "Add a cafe" flow.
class AddCafeState extends ChangeNotifier {
  // Step 1
  String? imagePath;
  bool isUploading = false;
  double uploadProgress = 0; // 0..1
  String briefName = '';

  // Step 2
  String cafeName = '';
  String area = '';
  String address = '';
  String openTime = '';

  // Step 3
  final Set<String> vibes = {};
  final Set<String> features = {};
  final List<String> signatureDrinks = ['', ''];

  // Step 4
  String story = '';

  void setImagePath(String? path) {
    imagePath = path;
    notifyListeners();
  }

  void setUploading(bool value, {double progress = 0}) {
    isUploading = value;
    uploadProgress = progress;
    notifyListeners();
  }

  void setBriefName(String value) {
    briefName = value;
    notifyListeners();
  }

  void setCafeName(String value) {
    cafeName = value;
    notifyListeners();
  }

  void setArea(String value) {
    area = value;
    notifyListeners();
  }

  void setAddress(String value) {
    address = value;
    notifyListeners();
  }

  void setOpenTime(String value) {
    openTime = value;
    notifyListeners();
  }

  void toggleVibe(String vibe) {
    if (!vibes.remove(vibe)) vibes.add(vibe);
    notifyListeners();
  }

  void toggleFeature(String feature) {
    if (!features.remove(feature)) features.add(feature);
    notifyListeners();
  }

  void setSignatureDrink(int index, String value) {
    if (index < signatureDrinks.length) {
      signatureDrinks[index] = value;
      notifyListeners();
    }
  }

  void addSignatureDrinkSlot() {
    signatureDrinks.add('');
    notifyListeners();
  }

  void setStory(String value) {
    story = value;
    notifyListeners();
  }

  bool get step1Valid => briefName.trim().isNotEmpty && imagePath != null;

  bool get step2Valid =>
      cafeName.trim().isNotEmpty &&
      area.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      openTime.trim().isNotEmpty;

  bool get step3Valid => vibes.isNotEmpty || features.isNotEmpty;

  bool get step4Valid => story.trim().isNotEmpty;
}