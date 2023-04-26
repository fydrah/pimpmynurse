import 'package:flutter/material.dart';
import 'package:pimpmynurse/utils/kv_store.dart';

class ThemeModeSetting {
  static const String _settingName = 'theme_mode';
  static const ThemeMode _default = ThemeMode.dark;

  static ThemeMode get() {
    switch (KVStore.localStorage.getString(_settingName)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        set(_default);
        return _default;
    }
  }

  static void change() {
    switch (KVStore.localStorage.getString(_settingName)) {
      case 'light':
        set(ThemeMode.dark);
        break;
      case 'dark':
        set(ThemeMode.light);
        break;
      default:
        break;
    }
  }

  static void set(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        KVStore.localStorage.setString(_settingName, themeMode.name);
        break;
      case ThemeMode.dark:
        KVStore.localStorage.setString(_settingName, themeMode.name);
        break;
      default:
        KVStore.localStorage.setString(_settingName, ThemeMode.dark.name);
    }
  }
}

extension ThemeModeIcons on ThemeMode {
  Icon get icon {
    switch (this) {
      case ThemeMode.light:
        return const Icon(Icons.wb_sunny);
      case ThemeMode.dark:
        return const Icon(Icons.bedtime);
      default:
        return const Icon(Icons.error);
    }
  }

  Icon get iconOpposite {
    switch (this) {
      case ThemeMode.light:
        return const Icon(Icons.bedtime);
      case ThemeMode.dark:
        return const Icon(Icons.wb_sunny);
      default:
        return const Icon(Icons.error);
    }
  }
}
