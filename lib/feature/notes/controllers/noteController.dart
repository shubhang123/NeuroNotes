import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/models/noteModel.dart';
import 'package:neuronotes/feature/notes/services/database.dart';
import 'package:get/get.dart';

class NoteController extends GetxController {
  RxList<NoteModel> noteList = RxList<NoteModel>();
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> bodyController = TextEditingController().obs;

  // ignore: invalid_use_of_protected_member
  List<NoteModel> get notes => noteList.value;

  @override
  void onInit() {
    String uid = Get.find<AuthController>().user!.uid;
    print("NoteController onit :: $uid");
    noteList
        .bindStream(Database().noteStream(uid)); //stream coming from firebase
    super.onInit();
  }
}
