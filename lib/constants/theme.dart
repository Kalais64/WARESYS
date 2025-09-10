import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00875A);
  static const Color secondaryGreen = Color(0xFF006C46);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryGreen,
      secondaryGreen,
    ],
  );

  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    color: Colors.white,
  );

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: primaryGreen,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );

  static InputDecoration textFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: Colors.grey,
        fontSize: 14,
      ),
    );
  }

  static const TextStyle bodyTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryGreen,
  );

  static const TextStyle cardSubtitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: Colors.grey,
  );
}