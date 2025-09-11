import 'package:flutter/material.dart';
import '../constants/theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/warehouse_bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                AppTheme.primaryGreen.withValues(alpha: 0.85),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: SafeArea(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    const Text(
                      'LogAn',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                    color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Login with Email Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          'Login with Email',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Login with Phone Number Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          side: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/login-options'),
                        child: const Text(
                          'Login with Phone Number',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                    const SizedBox(height: 16),
                    // Make Account Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          side: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          'Make Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Terms and Conditions Text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        children: [
                          const TextSpan(text: 'By logging in or using another login method, i agree with '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(text: ' from '),
                          TextSpan(
                            text: 'Waresys',
                      style: TextStyle(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                      ),
                    ),
                        ],
                  ),
                ),
              ],
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