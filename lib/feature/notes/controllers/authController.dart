import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/userController.dart';
import 'package:neuronotes/feature/notes/models/user.dart';
import 'package:neuronotes/feature/notes/services/database.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _firebaseUser;
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final String usersCollection = "users";
  final Rx<UserModel?> userModel = UserModel(id: '', name: '', email: '').obs;
  final Rx<int> axisCount = 2.obs;

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    super.onInit();
  }

  void createUser() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      final user = UserModel(
        id: userCredential.user?.uid ?? '',
        name: name.text,
        email: email.text,
      );
      final success = await Database().createNewUser(user);
      if (success) {
        Get.find<UserController>().user = user;
        Get.back();
        _clearControllers();
      }
    } catch (e) {
      Get.snackbar(
        'Error creating account',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void login() async {
    try {
      print("IN logging in email ${email.text} password ${password.text}");
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      final user = await Database().getUser(userCredential.user?.uid ?? '');
      Get.find<UserController>().user = user;
      _clearControllers();
    } catch (e) {
      Get.snackbar(
        'Error logging in',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void signout() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().user = UserModel(id: '', name: '', email: '');
    } catch (e) {
      Get.snackbar(
        'Error signing out',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }
}
