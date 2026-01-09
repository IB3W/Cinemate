import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool get isAuthenticated => false;
  bool get isEmailVerified => false;
}
