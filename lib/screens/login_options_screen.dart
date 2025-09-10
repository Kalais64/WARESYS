import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/theme.dart';
import '../services/auth_service.dart';

class LoginOptionsScreen extends StatefulWidget {
  const LoginOptionsScreen({super.key});

  @override
  State<LoginOptionsScreen> createState() => _LoginOptionsScreenState();
}

class _LoginOptionsScreenState extends State<LoginOptionsScreen> {
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential.user != null && mounted) {
        final role = await _authService.getUserRole();
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign In failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await _authService.signInWithApple();
      if (userCredential.user != null && mounted) {
        final role = await _authService.getUserRole();
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple Sign In failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.mainGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hallo\nPerintis',
                      style: AppTheme.headingStyle,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Masuk dengan Nomor Telepon',
                            style: AppTheme.cardTitleStyle,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Nomor Telepon',
                            style: AppTheme.bodyTextStyle,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: AppTheme.textFieldDecoration('Masukkan nomor telepon Anda'),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: AppTheme.primaryButtonStyle,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            child: const Text('KIRIM OTP'),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Atau masuk dengan',
                              style: AppTheme.cardSubtitleStyle,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: _isLoading ? null : _handleGoogleSignIn,
                                child: _socialButton('assets/google.svg'),
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                onTap: _isLoading ? null : _handleAppleSignIn,
                                child: _socialButton('assets/apple.svg'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'By logging in with phone, I agree with Terms & Conditions and Privacy Policy from Waresys',
                        style: AppTheme.cardSubtitleStyle.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _socialButton(String iconPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        iconPath,
        height: 24,
        width: 24,
      ),
    );
  }
}
