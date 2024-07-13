import 'package:flutter/cupertino.dart';
import 'package:neuronotes/feature/home/home_page.dart';
import 'package:neuronotes/feature/notes/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AnimatedBottomNavigation extends StatefulWidget {
  @override
  _AnimatedBottomNavigationState createState() =>
      _AnimatedBottomNavigationState();
}

class _AnimatedBottomNavigationState extends State<AnimatedBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), ChatHomePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.8, // Shorter width
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.89),
                borderRadius: BorderRadius.circular(50), // Rounded border
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GNav(
                  haptic: true,
                  rippleColor: Colors.blue.shade50,
                  duration: Duration(milliseconds: 700),
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.transparent,
                  color: Colors.blue,
                  activeColor: Colors.blue.shade900,
                  tabActiveBorder:
                      Border.all(color: Colors.white.withOpacity(0.3)),
                  tabBackgroundColor: Colors.lightBlueAccent,
                  gap: 24,
                  tabs: [
                    GButton(
                      icon: CupertinoIcons.home,
                      text: 'Notes wall',
                    ),
                    GButton(
                      icon: CupertinoIcons.bars,
                      text: 'Features',
                    ),
                  ],
                  selectedIndex: _currentIndex,
                  onTabChange: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
