import 'package:flutter/material.dart';
import '../widgets/app_background.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoOffset;
  late final Animation<double> _fade;

  String _typedText = '';
  final String _appName = 'SRMatrix';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOffset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.1))
        .animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await _logoController.forward();
    _startTypingEffect();
  }

  void _startTypingEffect() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 150));
      if (_charIndex < _appName.length) {
        setState(() {
          _typedText += _appName[_charIndex];
          _charIndex++;
        });
        return true;
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
        _textController.forward();
        await Future.delayed(const Duration(milliseconds: 1000));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const DashboardScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 1500),
            ),
          );
        }
        return false;
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: _logoOffset,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _typedText,
                        style: const TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 50,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _charIndex > 0 && _charIndex < _appName.length ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 12,
                          height: 45,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _fade,
                child: const Text(
                  'Welcome to your academic tracker',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}