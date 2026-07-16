import 'package:flutter/material.dart';

/// Holds all mutable state for the Register screen.
class RegisterState extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  DateTime? _dateOfBirth;
  String _countryDialCode = '+1';
  String _countryFlagEmoji = '🇺🇸';
  String _phone = '';
  String _password = '';
  bool _obscurePassword = true;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  DateTime? get dateOfBirth => _dateOfBirth;
  String get countryDialCode => _countryDialCode;
  String get countryFlagEmoji => _countryFlagEmoji;
  String get phone => _phone;
  String get password => _password;
  bool get obscurePassword => _obscurePassword;

  bool get canSubmit =>
      _firstName.trim().isNotEmpty &&
          _lastName.trim().isNotEmpty &&
          _email.trim().isNotEmpty &&
          _dateOfBirth != null &&
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

  void setDateOfBirth(DateTime value) {
    _dateOfBirth = value;
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