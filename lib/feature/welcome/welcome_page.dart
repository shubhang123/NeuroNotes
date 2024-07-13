import 'package:neuronotes/core/config/assets_constants.dart';
import 'package:neuronotes/core/extension/context.dart';
import 'package:neuronotes/feature/home/widgets/background_curves_painter.dart';
import 'package:neuronotes/feature/notes/screens/auth/login.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Positioned(
                left: -300,
                top: -00,
                child: Container(
                  height: 500,
                  width: 600,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.blueAccent,
                        Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: BackgroundCurvesPainter(),
                size: Size.infinite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(4, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo_vertical.png',
                      color: Colors.blue,
                      width: 400,
                    ),
                    Text(
                      'Create Notes Quickly & \nChat with PDF & Images!',
                      style: context.textTheme.bodyLarge!.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );

                        /*final TextEditingController apiKeyController =
                            TextEditingController();

                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return APIKeyBottomSheet(
                              apiKeyController: apiKeyController,
                              isCalledFromHomePage: false,
                            );
                          },
                        );*/
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        'Get Started',
                        style: context.textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
