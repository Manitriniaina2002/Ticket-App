import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            final currentMode = themeProvider.themeMode;
            ThemeMode newMode;
            
            switch (currentMode) {
              case ThemeMode.system:
                newMode = ThemeMode.dark;
                break;
              case ThemeMode.light:
                newMode = ThemeMode.dark;
                break;
              case ThemeMode.dark:
                newMode = ThemeMode.light;
                break;
            }
            
            themeProvider.setThemeMode(newMode);
          },
        );
      },
    );
  }
}
