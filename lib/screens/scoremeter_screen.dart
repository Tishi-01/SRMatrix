import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class ScoremeterScreen extends StatefulWidget {
  const ScoremeterScreen({super.key});

  @override
  State<ScoremeterScreen> createState() => _ScoremeterScreenState();
}

class _ScoremeterScreenState extends State<ScoremeterScreen> {
  final TextEditingController _internalController = TextEditingController();
  String _selectedGrade = 'O';

  final Map<String, int> gradeThreshold = {
    'O': 91,
    'A+': 81,
    'A': 71,
    'B+': 61,
    'B': 51,
    'C': 50,
  };

  final List<String> grades = ['O', 'A+', 'A', 'B+', 'B', 'C'];

  void _calculateRequiredMarks() {
    final int internal = int.tryParse(_internalController.text) ?? 0;

    if (internal > 60) {
      _showDialog('❗', 'Invalid Input', 'Internal marks cannot exceed 60');
      return;
    }

    if (internal < 10) {
      _showDialog('❗', 'Too Low', 'Marks too low to pass');
      return;
    }

    final int totalNeeded = gradeThreshold[_selectedGrade]!;

    if (internal >= totalNeeded) {
      _showDialog('🎉', 'Already Achieved', 'You have already secured $_selectedGrade grade');
      return;
    }

    int externalNeeded = totalNeeded - internal;
    double requiredOutOf75 = (externalNeeded * 75) / 40;

    if (requiredOutOf75 > 75) {
      _showDialog('⚠', 'Not Possible', 'Cannot achieve $_selectedGrade grade anymore');
      return;
    }

    _showDialog(
      '🎯',
      'YOU NEED TO SCORE',
      '${requiredOutOf75.ceil()} / 75',
      bottomText: 'IN END SEM\nTO ACHIEVE\nTARGETED GRADE',
    );
  }

  void _showDialog(String emoji, String title, String bigText, {String? bottomText}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Score Result',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Mokoto',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          bigText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Mokoto',
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                        if (bottomText != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            bottomText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Mokoto',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 30,
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

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Mokoto',
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black, fontFamily: 'Times New Roman'),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Times New Roman'),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGradeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'ENTER TARGET GRADE',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Mokoto',
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: _selectedGrade,
              onChanged: (value) => setState(() => _selectedGrade = value!),
              items: grades.map((grade) => DropdownMenuItem(value: grade, child: Text(grade))).toList(),
              underline: const SizedBox(),
              style: const TextStyle(fontFamily: 'Times New Roman', color: Colors.black),
              dropdownColor: Colors.white,
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand( // 🔧 Important: Ensure background fills the whole screen
        child: AppBackground(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/logo.png', height: 85),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'SCOREMETER',
                      style: TextStyle(
                        fontFamily: 'Mokoto',
                        fontSize: 26,
                        color: Colors.black,
                        shadows: [
                          Shadow(blurRadius: 5, color: Colors.black26, offset: Offset(0, 5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'FOR A SUBJECT:',
                    style: TextStyle(fontFamily: 'Mokoto', fontSize: 27, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 40),
                _buildInputField('ENTER INTERNAL MARKS', 'Out of 60...', _internalController),
                const SizedBox(height: 40),
                _buildGradeDropdown(),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      elevation: 10,
                    ),
                    onPressed: _calculateRequiredMarks,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}