import 'package:flutter/material.dart';
import '../widgets/app_background.dart'; 
import 'attendance_screen.dart';
import 'cgpa_screen.dart';
import 'sgpa_screen.dart';
import 'scoremeter_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.08),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/logo.png', height: screenHeight * 0.12),
                          SizedBox(width: screenWidth * 0.04),
                          Text(
                            'SRMATRIX',
                            style: TextStyle(
                              fontFamily: 'Mokoto',
                              fontSize: screenWidth * 0.09,
                              color: Colors.black,
                              shadows: const [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black26,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.08),

                      _buildMenuButton(
                        context,
                        icon: 'assets/attendance_icon.png',
                        label: 'ATTENDANCE',
                        destination: const AttendanceScreen(),
                        screenWidth: screenWidth,
                      ),
                      _buildMenuButton(
                        context,
                        icon: 'assets/cgpa_icon.png',
                        label: 'CGPA',
                        destination: const CgpaScreen(),
                        screenWidth: screenWidth,
                      ),
                      _buildMenuButton(
                        context,
                        icon: 'assets/sgpa_icon.png',
                        label: 'SGPA',
                        destination: const SgpaScreen(),
                        screenWidth: screenWidth,
                      ),
                      _buildMenuButton(
                        context,
                        icon: 'assets/scoremeter_icon.png',
                        label: 'SCOREMETER',
                        destination: const ScoremeterScreen(),
                        screenWidth: screenWidth,
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

  Widget _buildMenuButton(BuildContext context,
      {required String icon, required String label, required Widget destination, required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Image.asset(icon, height: 45, color: Colors.white),
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontFamily: 'Mokoto',
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}