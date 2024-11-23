import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Color signInButtonColor = const Color(0xFFB4BA1C); // Initial green color
  Color registerButtonColor = const Color(0xFFB4BA1C); // Initial green color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/Images/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black54,
                  Colors.black26,
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Sacred Strings',
                  style: TextStyle(
                    fontSize: 36, // Reduced font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Sign In Button
                buildButton(
                  context,
                  'SIGN IN',
                  signInButtonColor,
                  Colors.white,
                  const loginScreen(),
                  (Color color) {
                    setState(() {
                      signInButtonColor = color;
                    });
                  },
                ),
                const SizedBox(height: 15),
                // Register Button
                buildButton(
                  context,
                  'REGISTER',
                  registerButtonColor,
                  Colors.white,
                  const RegScreen(),
                  (Color color) {
                    setState(() {
                      registerButtonColor = color;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    Color textColor,
    Widget nextPage,
    Function(Color) onColorChange,
  ) {
    return MouseRegion(
      onEnter: (_) => onColorChange(Colors.white), // Change to white on hover
      onExit: (_) => onColorChange(backgroundColor), // Revert to original color
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 40,
          width: 200,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
