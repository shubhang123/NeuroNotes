import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:neuronotes/feature/notes/controllers/authController.dart';
import 'package:neuronotes/feature/notes/controllers/noteController.dart';
import 'package:neuronotes/feature/notes/models/noteModel.dart';
import 'package:neuronotes/feature/notes/screens/home/show_note.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoteList extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final NoteController noteController = Get.find<NoteController>();

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

  final int axisCount;

  NoteList(
      {super.key, required List<NoteModel> notes, required this.axisCount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MasonryGridView.count(
        crossAxisCount: axisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: noteController.notes.length,
        itemBuilder: (context, index) => buildNoteItem(context, index),
      ),
    );
  }

  Widget buildNoteItem(BuildContext context, int index) {
    var formattedDate = DateFormat.yMMMd()
        .format(noteController.notes[index].creationDate.toDate());
    Random random = Random();
    Color bg = lightColors[random.nextInt(lightColors.length)];

    return GestureDetector(
      onTap: () {
        // Use standard Flutter navigation to navigate to the ShowNote screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowNote(
              index: index,
              noteData: noteController.notes[index],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteController.notes[index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              noteController.notes[index].body,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
