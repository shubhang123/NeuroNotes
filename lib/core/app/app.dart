import 'package:neuronotes/core/app/style.dart';
import 'package:neuronotes/core/navigation/router.dart';
import 'package:flutter/material.dart';

class NeuroNotes extends StatelessWidget {
  const NeuroNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NeuroNotes',
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
