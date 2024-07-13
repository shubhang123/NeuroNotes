// ignore_for_file: lines_longer_than_80_chars

import 'package:neuronotes/core/navigation/route.dart';
import 'package:neuronotes/feature/chat/chat_page.dart';
import 'package:neuronotes/feature/home/home_page.dart';
import 'package:neuronotes/feature/notes/screens/auth/login.dart';
import 'package:neuronotes/feature/notes/utils/tab.dart';
import 'package:neuronotes/feature/welcome/welcome_page.dart';
import 'package:neuronotes/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoute.splash.path,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoute.home.path,
      builder: (context, state) => AnimatedBottomNavigation(),
    ),
    GoRoute(
      path: AppRoute.chat.path,
      builder: (context, state) => ChatPage(),
    ),
    GoRoute(
      path: AppRoute.welcome.path,
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => Login(),
    ),
  ],
);
