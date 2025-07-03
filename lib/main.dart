import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/app_background.dart'; // background wrapper widget
import 'screens/splash_screen.dart'; 
void main() {
  runApp(const SRMatrixApp());
}

class SRMatrixApp extends StatelessWidget {
  const SRMatrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRMatrix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Mokoto',
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SmoothTransitionBuilder(),
            TargetPlatform.iOS: SmoothTransitionBuilder(),
          },
        ),
      ),
      home: const SplashScreen(), 
    );
  }
}

// 👇 Add the transition builder directly in this file
class SmoothTransitionBuilder extends PageTransitionsBuilder {
  const SmoothTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0); // Slide from bottom
    const end = Offset.zero;
    const curve = Curves.easeInOut;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: animation.drive(fadeTween),
        child: child,
      ),
    );
  }
}