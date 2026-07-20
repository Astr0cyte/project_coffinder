// // import 'package:flutter/material.dart';
// //
// // /// Holds all data collected across the 4-step "Add a cafe" flow.
// // class AddCafeState extends ChangeNotifier {
// //   // Step 1
// //   String? imagePath;
// //   bool isUploading = false;
// //   double uploadProgress = 0; // 0..1
// //   String briefName = '';
// //   String? _imageUrl;
// //   String? get imageUrl => _imageUrl;
// //
// //
// //   // Step 2
// //   String cafeName = '';
// //   String area = '';
// //   String address = '';
// //   String openTime = '';
// //
// //   // Step 3
// //   final Set<String> vibes = {};
// //   final Set<String> features = {};
// //   final List<String> signatureDrinks = ['', ''];
// //
// //   // Step 4
// //   String story = '';
// //
// //   void setImagePath(String? path) {
// //     imagePath = path;
// //     notifyListeners();
// //   }
// //
// //   void setUploading(bool value, {double progress = 0}) {
// //     isUploading = value;
// //     uploadProgress = progress;
// //     notifyListeners();
// //   }
// //
// //   void setBriefName(String value) {
// //     briefName = value;
// //     notifyListeners();
// //   }
// //
// //   void setCafeName(String value) {
// //     cafeName = value;
// //     notifyListeners();
// //   }
// //
// //   void setArea(String value) {
// //     area = value;
// //     notifyListeners();
// //   }
// //
// //   void setImageUrl(String? url) {
// //     _imageUrl = url;
// //     notifyListeners();
// //   }
// //
// //
// //   void setAddress(String value) {
// //     address = value;
// //     notifyListeners();
// //   }
// //
// //   void setOpenTime(String value) {
// //     openTime = value;
// //     notifyListeners();
// //   }
// //
// //   void toggleVibe(String vibe) {
// //     if (!vibes.remove(vibe)) vibes.add(vibe);
// //     notifyListeners();
// //   }
// //
// //   void toggleFeature(String feature) {
// //     if (!features.remove(feature)) features.add(feature);
// //     notifyListeners();
// //   }
// //
// //   void setSignatureDrink(int index, String value) {
// //     if (index < signatureDrinks.length) {
// //       signatureDrinks[index] = value;
// //       notifyListeners();
// //     }
// //   }
// //
// //   void addSignatureDrinkSlot() {
// //     signatureDrinks.add('');
// //     notifyListeners();
// //   }
// //
// //   void setStory(String value) {
// //     story = value;
// //     notifyListeners();
// //   }
// //
// //   bool get step1Valid => briefName.trim().isNotEmpty && imagePath != null;
// //
// //   bool get step2Valid =>
// //       cafeName.trim().isNotEmpty &&
// //       area.trim().isNotEmpty &&
// //       address.trim().isNotEmpty &&
// //       openTime.trim().isNotEmpty;
// //
// //   bool get step3Valid => vibes.isNotEmpty || features.isNotEmpty;
// //
// //   bool get step4Valid => story.trim().isNotEmpty;
// // }
//
//
// import 'package:flutter/foundation.dart';
//
// /// State dùng chung xuyên suốt 4 bước "Add cafe" (Step1 -> Step4).
// /// Truyền 1 instance duy nhất qua constructor của từng StepXPage.
// class AddCafeState extends ChangeNotifier {
//   // ================== STEP 1: ẢNH ==================
//   String? _imageUrl;
//   String? get imageUrl => _imageUrl;
//
//   void setImageUrl(String? url) {
//     _imageUrl = url;
//     notifyListeners();
//   }
//
//   // ================== STEP 2: THÔNG TIN ==================
//   String _cafeName = '';
//   String get cafeName => _cafeName;
//   void setCafeName(String value) {
//     _cafeName = value;
//     notifyListeners();
//   }
//
//   String _area = '';
//   String get area => _area;
//   void setArea(String value) {
//     _area = value;
//     notifyListeners();
//   }
//
//   String _address = '';
//   String get address => _address;
//   void setAddress(String value) {
//     _address = value;
//     notifyListeners();
//   }
//
//   String _openTime = '';
//   String get openTime => _openTime;
//   void setOpenTime(String value) {
//     _openTime = value;
//     notifyListeners();
//   }
//
//   /// Step 2 hợp lệ khi đủ 4 field bắt buộc.
//   bool get step2Valid =>
//       _cafeName.trim().isNotEmpty &&
//           _area.trim().isNotEmpty &&
//           _address.trim().isNotEmpty &&
//           _openTime.trim().isNotEmpty;
//
//   // ================== STEP 3: ĐẶC ĐIỂM ==================
//   final Set<String> vibes = {};
//   final Set<String> features = {};
//   final List<String> signatureDrinks = [];
//
//   void toggleVibe(String vibe) {
//     if (vibes.contains(vibe)) {
//       vibes.remove(vibe);
//     } else {
//       vibes.add(vibe);
//     }
//     notifyListeners();
//   }
//
//   void toggleFeature(String feature) {
//     if (features.contains(feature)) {
//       features.remove(feature);
//     } else {
//       features.add(feature);
//     }
//     notifyListeners();
//   }
//
//   void addSignatureDrinkSlot() {
//     signatureDrinks.add('');
//     notifyListeners();
//   }
//
//   void setSignatureDrink(int index, String value) {
//     if (index < 0 || index >= signatureDrinks.length) return;
//     signatureDrinks[index] = value;
//     notifyListeners();
//   }
//
//   /// Step 3 không bắt buộc chọn gì cả -> luôn hợp lệ.
//   /// Đổi lại thành điều kiện cụ thể nếu bạn muốn bắt buộc
//   /// (vd: vibes.isNotEmpty || features.isNotEmpty).
//   bool get step3Valid => true;
//
//   // ================== STEP 4: CÂU CHUYỆN ==================
//   String _story = '';
//   String get story => _story;
//   void setStory(String value) {
//     _story = value;
//     notifyListeners();
//   }
//
//   /// Tên ngắn hiển thị ở preview, để trống thì Step4 sẽ tự fallback về cafeName.
//   String _briefName = '';
//   String get briefName => _briefName;
//   void setBriefName(String value) {
//     _briefName = value;
//     notifyListeners();
//   }
//
//   /// Reset toàn bộ state, gọi sau khi đăng quán thành công nếu muốn dùng lại form.
//   void reset() {
//     _imageUrl = null;
//     _cafeName = '';
//     _area = '';
//     _address = '';
//     _openTime = '';
//     vibes.clear();
//     features.clear();
//     signatureDrinks.clear();
//     _story = '';
//     _briefName = '';
//     notifyListeners();
//   }
// }


import 'package:flutter/foundation.dart';

/// State dùng chung xuyên suốt 4 bước "Add cafe" (Step1 -> Step4).
/// Truyền 1 instance duy nhất qua constructor của từng StepXPage.
class AddCafeState extends ChangeNotifier {
  // ================== STEP 1: ẢNH ==================
  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  void setImageUrl(String? url) {
    _imageUrl = url;
    notifyListeners();
  }

  // ================== STEP 2: THÔNG TIN ==================
  String _cafeName = '';
  String get cafeName => _cafeName;
  void setCafeName(String value) {
    _cafeName = value;
    notifyListeners();
  }

  String _area = '';
  String get area => _area;
  void setArea(String value) {
    _area = value;
    notifyListeners();
  }

  String _address = '';
  String get address => _address;
  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  String _openTime = '';
  String get openTime => _openTime;
  void setOpenTime(String value) {
    _openTime = value;
    notifyListeners();
  }

  /// Step 2 hợp lệ khi đủ 4 field bắt buộc.
  bool get step2Valid =>
      _cafeName.trim().isNotEmpty &&
          _area.trim().isNotEmpty &&
          _address.trim().isNotEmpty &&
          _openTime.trim().isNotEmpty;

  // ================== STEP 3: ĐẶC ĐIỂM ==================
  final Set<String> vibes = {};
  final Set<String> features = {};
  final List<String> signatureDrinks = [];

  void toggleVibe(String vibe) {
    if (vibes.contains(vibe)) {
      vibes.remove(vibe);
    } else {
      vibes.add(vibe);
    }
    notifyListeners();
  }

  void toggleFeature(String feature) {
    if (features.contains(feature)) {
      features.remove(feature);
    } else {
      features.add(feature);
    }
    notifyListeners();
  }

  void addSignatureDrinkSlot() {
    signatureDrinks.add('');
    notifyListeners();
  }

  void setSignatureDrink(int index, String value) {
    if (index < 0 || index >= signatureDrinks.length) return;
    signatureDrinks[index] = value;
    notifyListeners();
  }

  /// Step 3 không bắt buộc chọn gì cả -> luôn hợp lệ.
  /// Đổi lại thành điều kiện cụ thể nếu bạn muốn bắt buộc
  /// (vd: vibes.isNotEmpty || features.isNotEmpty).
  bool get step3Valid => true;

  // ================== STEP 4: CÂU CHUYỆN ==================
  String _story = '';
  String get story => _story;
  void setStory(String value) {
    _story = value;
    notifyListeners();
  }

  /// Tên ngắn hiển thị ở preview, để trống thì Step4 sẽ tự fallback về cafeName.
  String _briefName = '';
  String get briefName => _briefName;
  void setBriefName(String value) {
    _briefName = value;
    notifyListeners();
  }

  /// Reset toàn bộ state, gọi sau khi đăng quán thành công nếu muốn dùng lại form.
  void reset() {
    _imageUrl = null;
    _cafeName = '';
    _area = '';
    _address = '';
    _openTime = '';
    vibes.clear();
    features.clear();
    signatureDrinks.clear();
    _story = '';
    _briefName = '';
    notifyListeners();
  }
}