import 'package:flutter/material.dart';

/// Holds all mutable state for the Sign In screen.
class SignInState extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _rememberMe = false;
  bool _obscurePassword = true;

  String get email => _email;
  String get password => _password;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;

  bool get canSubmit => _email.trim().isNotEmpty && _password.isNotEmpty;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void toggleRememberMe([bool? value]) {
    _rememberMe = value ?? !_rememberMe;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
}