import 'package:neuronotes/feature/notes/utils/tab.dart';
import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/screens/auth/login.dart';
import 'package:get/get.dart';

class Root extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.user != null) {
        return AnimatedBottomNavigation();
      } else {
        return Login();
      }
    });
  }
}
