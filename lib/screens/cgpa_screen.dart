import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class CgpaScreen extends StatefulWidget {
  const CgpaScreen({super.key});

  @override
  State<CgpaScreen> createState() => _CgpaScreenState();
}

class _CgpaScreenState extends State<CgpaScreen> {
  final List<TextEditingController> _controllers = [TextEditingController()];

  void _addField() {
    if (_controllers.length < 10) {
      setState(() => _controllers.add(TextEditingController()));
    }
  }

  void _removeField() {
    if (_controllers.length > 1) {
      setState(() => _controllers.removeLast());
    }
  }

  void _calculateCgpa() {
    double sum = 0;
    int count = 0;
    for (var controller in _controllers) {
      final value = double.tryParse(controller.text);
      if (value != null) {
        sum += value;
        count++;
      }
    }
    double cgpa = count == 0 ? 0 : sum / count;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'CGPA Result',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "YOU SCORED",
                        style: TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cgpa.toStringAsFixed(2),
                        style: const TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "CGPA",
                        style: TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 40,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Image.asset('assets/logo.png', height: 85),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'CGPA',
                            style: TextStyle(
                              fontFamily: 'Mokoto',
                              fontSize: 38,
                              color: Colors.black,
                              shadows: [
                                Shadow(blurRadius: 5, color: Colors.black26, offset: Offset(0, 5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(25),
                        color: Colors.black,
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Text('  SEM', style: TextStyle(fontFamily: 'Mokoto', fontSize: 30, color: Colors.white)),
                                Text('      SGPA', style: TextStyle(fontFamily: 'Mokoto', fontSize: 30, color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            for (int i = 0; i < _controllers.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 50),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        '${_toRoman(i + 1)}',
                                        style: const TextStyle(
                                          fontFamily: 'Mokoto',
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 35),
                                    SizedBox(
                                      width: 120,
                                      child: TextField(
                                        controller: _controllers[i],
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontFamily: 'Times New Roman'),
                                        decoration: const InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Opacity(
                            opacity: _controllers.length >= 8 ? 0.5 : 1.0,
                            child: IconButton(
                              onPressed: _controllers.length >= 8 ? null : _addField,
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                          Opacity(
                            opacity: _controllers.length <= 1 ? 0.5 : 1.0,
                            child: IconButton(
                              onPressed: _controllers.length <= 1 ? null : _removeField,
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            elevation: 10,
                          ),
                          onPressed: _calculateCgpa,
                          child: const Text(
                            'CALCULATE',
                            style: TextStyle(
                              fontFamily: 'Mokoto',
                              fontSize: 22,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _toRoman(int number) {
    const romanNumerals = {
      1: 'I',
      2: 'II',
      3: 'III',
      4: 'IV',
      5: 'V',
      6: 'VI',
      7: 'VII',
      8: 'VIII',
      9: 'IX',
      10: 'X',
    };
    return romanNumerals[number] ?? number.toString();
  }
}