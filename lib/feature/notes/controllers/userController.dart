import 'package:neuronotes/feature/notes/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _userModel = UserModel(id: '', name: '', email: '').obs;

  UserModel? get user => _userModel.value;

  set user(UserModel? value) {
    if (value != null) {
      _userModel.value = UserModel(
        id: value.id,
        name: value.name,
        email: value.email,
      );
    } else {
      _userModel.value = null;
    }
  }

  void clear() {
    _userModel.value = UserModel(id: '', name: '', email: '');
  }
}
