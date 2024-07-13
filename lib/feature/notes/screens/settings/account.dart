import 'package:neuronotes/feature/notes/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/controllers/userController.dart';
import 'package:neuronotes/feature/notes/screens/widgets/custom_icon_btn.dart';
import 'package:get/get.dart';

class Account extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  Account({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Account",
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
              Container(
                padding: const EdgeInsets.all(10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Hi, ${userController.user!.name} !\n",
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      const WidgetSpan(
                          child: Icon(
                            Icons.email,
                            size: 14,
                          ),
                          alignment: PlaceholderAlignment.middle),
                      TextSpan(
                        text: "   ${userController.user!.email}\n",
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                onTap: () {
                  showSignOutDialog(context);
                },
                title: const Text("Logout"),
                leading: Icon(
                  Icons.power_settings_new_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSignOutDialog(BuildContext context) async {
  final AuthController authController = Get.find<AuthController>();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        actionsPadding: const EdgeInsets.only(right: 60),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          "Are you sure you want to log out?",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Your notes are already saved so when logging back your noteswill be there.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              // Sign out the user
              authController.signout();
              // Navigate back to the previous screen
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: Text("Log Out",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
          TextButton(
            child: Text("Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
