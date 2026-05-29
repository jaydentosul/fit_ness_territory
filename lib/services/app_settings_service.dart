import 'package:flutter/material.dart';

class AppSettingsService {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static ValueNotifier<bool> notificationsOn = ValueNotifier(true);
  static ValueNotifier<bool> privateProfile = ValueNotifier(false);
}