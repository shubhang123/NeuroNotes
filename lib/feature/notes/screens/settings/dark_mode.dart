import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/screens/settings/widgets/list_tile.dart';
import 'package:neuronotes/feature/notes/screens/widgets/custom_icon_btn.dart';

class DarkMode extends StatelessWidget {
  const DarkMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomIconBtn(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                      color: Theme.of(context).colorScheme.surface,
                      onPressed: () {
                        // Use standard Flutter navigation to go back
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    const Text(
                      "Appearance",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTileSetting(
                  onTap: () {
                    // Use ThemeData.of(context).brightness to change the theme mode
                    if (Theme.of(context).brightness == Brightness.light) {
                      Theme.of(context).copyWith(brightness: Brightness.dark);
                    } else {
                      Theme.of(context).copyWith(brightness: Brightness.light);
                    }
                  },
                  title: "Use device setting",
                  iconData: Icons.settings_brightness_outlined,
                  subtitle: const Text(
                    "Automatically switch between Light and Dark themes when your system does",
                  )),
              ListTileSetting(
                onTap: () {
                  // Set the theme mode to light
                  Theme.of(context).copyWith(brightness: Brightness.light);
                },
                title: "Light Mode",
                iconData: Icons.brightness_5,
                subtitle: const Text('Light mode is the default theme'),
              ),
              ListTileSetting(
                iconData: Icons.brightness_4_outlined,
                onTap: () {
                  // Set the theme mode to dark
                  Theme.of(context).copyWith(brightness: Brightness.dark);
                },
                title: "Dark Mode",
                subtitle: const Text('Switch to Dark Mode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}