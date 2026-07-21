import 'package:flutter/material.dart';

/// Holds all mutable state for the Register screen.
class RegisterState extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _referralCode = '';
  String _countryDialCode = '+84';
  String _countryFlagEmoji = '🇻🇳';
  String _phone = '';
  String _password = '';
  bool _obscurePassword = true;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get referralCode => _referralCode;
  String get countryDialCode => _countryDialCode;
  String get countryFlagEmoji => _countryFlagEmoji;
  String get phone => _phone;
  String get password => _password;
  bool get obscurePassword => _obscurePassword;

  bool get canSubmit =>
      _firstName.trim().isNotEmpty &&
          _lastName.trim().isNotEmpty &&
          _email.trim().isNotEmpty &&
          _referralCode.trim().isNotEmpty &&
          _phone.trim().isNotEmpty &&
          _password.isNotEmpty;

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setReferralCode(String value) {
    _referralCode = value;
    notifyListeners();
  }

  void setCountry({required String dialCode, required String flagEmoji}) {
    _countryDialCode = dialCode;
    _countryFlagEmoji = flagEmoji;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
}