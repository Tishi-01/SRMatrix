import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _attendedController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  void _calculateAttendance() {
    final String attendedText = _attendedController.text;
    final String totalText = _totalController.text;

    if (attendedText.isEmpty || totalText.isEmpty) {
      _showDialog("⚠️", "Incomplete Input", "Please enter both values first");
      return;
    }

    final int attended = int.tryParse(attendedText) ?? 0;
    final int total = int.tryParse(totalText) ?? 0;

    if (total == 0) {
      _showDialog("⚠️", "Invalid Input", "Total classes cannot be zero");
      return;
    }

    final double percentage = (attended / total) * 100;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Attendance Result',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (_, animation, __, ___) => FadeTransition(
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
                      Text(
                        percentage > 75 ? "🎉" : "!",
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        percentage > 75
                            ? "YOU CAN BUNK"
                            : (percentage == 75
                                ? "BORDERLINE"
                                : "YOU NEED TO ATTEND"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        percentage == 75
                            ? "-"
                            : (percentage > 75
                                ? "${((attended - (0.75 * total)) / 0.75).floor()}"
                                : "${(((0.75 * total) - attended) / 0.25).ceil()}"),
                        style: const TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        percentage > 75
                            ? "CLASSES AND STILL MAINTAIN\n75% ATTENDANCE"
                            : (percentage == 75
                                ? "YOU ARE JUST AT 75%"
                                : "CLASSES TO ACHIEVE\n75% ATTENDANCE"),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Mokoto',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
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
      ),
    );
  }

  void _showDialog(String emoji, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          emoji,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 40),
        ),
        content: Text(
          "$title\n$message",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Mokoto',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: screenHeight * 0.05),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight * 0.9),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset('assets/logo.png', height: screenHeight * 0.105),
                        ),
                        const SizedBox(width: 10),
                        const Flexible(
                          child: Text(
                            'ATTENDANCE',
                            style: TextStyle(
                              fontFamily: 'Mokoto',
                              fontSize: 26,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black26,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'FOR A SUBJECT:',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Mokoto',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInputField('ENTER CLASSES ATTENDED', _attendedController),
                    const SizedBox(height: 30),
                    _buildInputField('ENTER TOTAL CLASSES', _totalController),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          elevation: 10,
                        ),
                        onPressed: _calculateAttendance,
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
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Mokoto',
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Times New Roman',
            ),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter Value...',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: 'Times New Roman',
              ),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}