import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/controllers/userController.dart';
import 'package:neuronotes/feature/notes/screens/widgets/custom_icon_btn.dart';
import 'package:neuronotes/feature/notes/services/database.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddNotePage extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  AddNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomIconBtn(
                  color: Theme.of(context).colorScheme.surface,
                  onPressed: () {
                    // Use standard Flutter navigation to go back
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                ),
                const Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: null,
                      autofocus: true,
                      controller: titleController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Title",
                      ),
                      style: const TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: bodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Type something...",
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          if (titleController.text.isEmpty && bodyController.text.isEmpty) {
            showEmptyTitleDialog(context);
          } else {
            Database().addNote(authController.user!.uid, titleController.text,
                bodyController.text);
            // Use standard Flutter navigation to go back
            Navigator.of(context).pop();
          }
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}

void showEmptyTitleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(
          "Notes is empty!",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'The content of the note cannot be empty to be saved.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Okay",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed: () {
              // Use standard Flutter navigation to close the dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
