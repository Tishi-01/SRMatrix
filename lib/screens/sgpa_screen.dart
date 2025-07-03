import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class SgpaScreen extends StatefulWidget {
  const SgpaScreen({super.key});

  @override
  State<SgpaScreen> createState() => _SgpaScreenState();
}

class _SgpaScreenState extends State<SgpaScreen> {
  final List<TextEditingController> _creditControllers = [TextEditingController()];
  final List<String> _grades = ['O'];
  int _count = 1;

  final List<String> gradeOptions = ['O', 'A+', 'A', 'B+', 'B', 'C', 'Ab', 'F'];

  void _addField() {
    if (_count < 7) {
      setState(() {
        _creditControllers.add(TextEditingController());
        _grades.add('O');
        _count++;
      });
    }
  }

  void _removeField() {
    if (_count > 1) {
      setState(() {
        _creditControllers.removeLast();
        _grades.removeLast();
        _count--;
      });
    }
  }

  void _calculateSgpa() {
    List<int> credit = [];
    List<int> gradePoints = [];

    for (int i = 0; i < _count; i++) {
      final c = int.tryParse(_creditControllers[i].text);
      if (c != null) {
        credit.add(c);

        switch (_grades[i]) {
          case 'O': gradePoints.add(10); break;
          case 'A+': gradePoints.add(9); break;
          case 'A': gradePoints.add(8); break;
          case 'B+': gradePoints.add(7); break;
          case 'B': gradePoints.add(6); break;
          case 'C': gradePoints.add(5); break;
          case 'Ab':
          case 'F': gradePoints.add(0); break;
        }
      }
    }

    int num = 0, den = 0;
    for (int i = 0; i < credit.length; i++) {
      num += credit[i] * gradePoints[i];
      den += credit[i];
    }

    double sgpa = den == 0 ? 0 : num / den;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SGPA Result',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (_, animation, __, ___) {
        return FadeTransition(
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
                        const Text('YOU SCORED', style: TextStyle(fontFamily: 'Mokoto', fontSize: 22, color: Colors.white)),
                        const SizedBox(height: 10),
                        Text(sgpa.toStringAsFixed(2), style: const TextStyle(fontFamily: 'Mokoto', fontSize: 40, color: Colors.white)),
                        const SizedBox(height: 10),
                        const Text('SGPA', style: TextStyle(fontFamily: 'Mokoto', fontSize: 22, color: Colors.white)),
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
        );
      },
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
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
                          const Text('SGPA', style: TextStyle(fontFamily: 'Mokoto', fontSize: 38, color: Colors.black, shadows: [Shadow(blurRadius: 5, color: Colors.black26, offset: Offset(0, 5))])),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.black,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('SUB', style: TextStyle(fontFamily: 'Mokoto', fontSize: 25, color: Colors.white)),
                                Text('CREDIT', style: TextStyle(fontFamily: 'Mokoto', fontSize: 25, color: Colors.white)),
                                Text('GRADE', style: TextStyle(fontFamily: 'Mokoto', fontSize: 25, color: Colors.white)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            for (int i = 0; i < _count; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(_toRoman(i + 1), textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Mokoto', fontSize: 18, color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: TextField(
                                        controller: _creditControllers[i],
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(fontFamily: 'Times New Roman'),
                                        decoration: const InputDecoration(filled: true, fillColor: Colors.white, isDense: true),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                      child: DropdownButton<String>(
                                        value: _grades[i],
                                        onChanged: (value) => setState(() => _grades[i] = value!),
                                        items: gradeOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                        underline: const SizedBox(),
                                        style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.black),
                                        dropdownColor: Colors.white,
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
                            opacity: _count >= 7 ? 0.5 : 1.0,
                            child: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _count >= 7 ? null : _addField),
                          ),
                          Opacity(
                            opacity: _count <= 1 ? 0.5 : 1.0,
                            child: IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: _count <= 1 ? null : _removeField),
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
                          onPressed: _calculateSgpa,
                          child: const Text('CALCULATE', style: TextStyle(fontFamily: 'Mokoto', fontSize: 22, color: Colors.white, letterSpacing: 2)),
                        ),
                      ),
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
    const map = {
      1: 'I', 2: 'II', 3: 'III', 4: 'IV', 5: 'V', 6: 'VI', 7: 'VII',
    };
    return map[number] ?? number.toString();
  }
}