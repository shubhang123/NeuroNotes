import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/models/noteModel.dart';
import 'package:neuronotes/feature/notes/screens/widgets/custom_icon_btn.dart';
import 'package:neuronotes/feature/notes/services/database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShowNote extends StatelessWidget {
  final NoteModel noteData;
  final int index;
  ShowNote({super.key, required this.noteData, required this.index});
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = noteData.title;
    bodyController.text = noteData.body;
    var formattedDate =
        DateFormat.yMMMd().format(noteData.creationDate.toDate());
    var time = DateFormat.jm().format(noteData.creationDate.toDate());

    // Define the list of light colors
    final lightColors = [
      Colors.amber.shade300,
      Colors.lightGreen.shade300,
      Colors.lightBlue.shade300,
      Colors.orange.shade300,
      Colors.pinkAccent.shade100,
      Colors.tealAccent.shade100,
      Colors.purpleAccent,
      Colors.greenAccent.shade400,
      Colors.cyanAccent,
    ];

    // Randomly select a color from the list
    final randomColor = lightColors[Random().nextInt(lightColors.length)];

    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(
              16.0,
            ),
            decoration: BoxDecoration(color: randomColor.withOpacity(1)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    CustomIconBtn(
                      color: Theme.of(context).colorScheme.surface,
                      onPressed: () {
                        showDeleteDialog(context, noteData);
                      },
                      icon: const Icon(
                        Icons.delete,
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
                        Text(
                          "$formattedDate at $time",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: titleController,
                          maxLines: null,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Title",
                          ),
                          style: const TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autofocus: true,
                          controller: bodyController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Type something...",
                          ),
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (titleController.text != noteData.title ||
                bodyController.text != noteData.body) {
              Database().updateNote(authController.user!.uid,
                  titleController.text, bodyController.text, noteData.id);
              // Use standard Flutter navigation to go back
              Navigator.of(context).pop();
              titleController.clear();
              bodyController.clear();
            } else {
              showSameContentDialog(context);
            }
          },
          label: const Text("Save"),
          icon: const Icon(Icons.save),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
        ));
  }
}

void showDeleteDialog(BuildContext context, noteData) {
  final AuthController authController = Get.find<AuthController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          "Delete Note?",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text("Are you sure you want to delete this note?",
            style: Theme.of(context).textTheme.titleMedium),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Yes",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
              Database().delete(authController.user!.uid, noteData.id);
              // Use standard Flutter navigation to go back
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              "No",
              style: Theme.of(context).textTheme.titleMedium,
            ),
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

void showSameContentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          "No change in content!",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text("There is no change in content.",
            style: Theme.of(context).textTheme.titleMedium),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Okay",
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
