import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/screens/settings/account.dart';
import 'package:neuronotes/feature/notes/screens/settings/dark_mode.dart';
import 'package:neuronotes/feature/notes/screens/settings/widgets/list_tile.dart';
import 'package:neuronotes/feature/notes/screens/widgets/custom_icon_btn.dart';
import 'package:get/get.dart';

class Setting extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  Setting({super.key});

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
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    const Text(
                      "Settings",
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
                  // Use standard Flutter navigation to navigate to the Account screen
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Account()),
                  );
                },
                title: "Logout",
                iconData: Icons.person,
                subtitle: Text('from  account'),
              ),
              ListTileSetting(
                onTap: () {
                  // Use standard Flutter navigation to navigate to the DarkMode screen
                },
                title: "By shubhang",
                iconData: Icons.group,
                subtitle: const Text('shriyash , vidushi '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
