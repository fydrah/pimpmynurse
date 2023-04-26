import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pimpmynurse/screens/home.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/utils/kv_store.dart';
import 'package:pimpmynurse/utils/flowsheet/init_flowsheet_data.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:pimpmynurse/utils/theme_mode_setting.dart';

void main() async {
  await Hive.initFlutter();
  await KVStore.init();

  AppBoxes.registerAdapters();

  await Future.wait(AppBoxes.openBoxes());

  initSolventsAndSolutions();
  initLossTypes();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode themeMode = ThemeModeSetting.get();

  @override
  Widget build(BuildContext context) {
    const FlexScheme usedScheme = FlexScheme.bahamaBlue;

    return MaterialApp(
      title: 'Pimp my nurse',

      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: usedScheme,
        // Use very subtly themed app bar elevation in light mode.
        appBarElevation: 0.5,
      ),
      // Same definition for the dark theme, but using FlexThemeData.dark().
      darkTheme: FlexThemeData.dark(
        scheme: usedScheme,
        // Use a bit more themed elevated app bar in dark mode.
        appBarElevation: 2,
      ),
      // Use the above dark or light theme based on active themeMode.
      themeMode: themeMode,

      home: Home(
        onThemeModeChanged: (ThemeMode value) {
          setState(() {
            themeMode = value;
          });
        },
      ),
    );
  }
}
