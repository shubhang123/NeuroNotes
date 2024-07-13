import 'package:flutter/material.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/controllers/noteController.dart';
import 'package:neuronotes/feature/notes/screens/home/add_note.dart';
import 'package:neuronotes/feature/notes/screens/home/note_list.dart';
import 'package:neuronotes/feature/notes/screens/settings/setting.dart';
import 'package:neuronotes/feature/notes/screens/widgets/custom_icon_btn.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<AuthController> {
  final AuthController authController = Get.find<AuthController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              child: Obx(
                () {
                  return Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomIconBtn(
                              color: Theme.of(context).colorScheme.surface,
                              onPressed: () {
                                authController.axisCount.value =
                                    authController.axisCount.value == 1 ? 2 : 1;
                              },
                              icon: Icon(authController.axisCount.value == 1
                                  ? Icons.grid_on
                                  : Icons.list),
                            ),
                            Image.asset(
                              'assets/images/logo_horizontal.png',
                              width: 180,
                              color: Colors.blue.shade50,
                            ),
                            CustomIconBtn(
                              color: Theme.of(context).colorScheme.surface,
                              onPressed: () {
                                // Use standard Flutter navigation to navigate to the Setting screen
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => Setting()),
                                );
                              },
                              icon: const Icon(
                                Icons.settings,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GetX<NoteController>(
                        init: Get.put<NoteController>(NoteController()),
                        builder: (NoteController noteController) {
                          return NoteList(
                            notes: noteController.notes,
                            axisCount: authController.axisCount.value,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0, right: 5),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                tooltip: "Add Note",
                onPressed: () {
                  // Use standard Flutter navigation to navigate to the AddNotePage
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddNotePage()),
                  );
                },
                child: const Icon(
                  Icons.note_add,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
