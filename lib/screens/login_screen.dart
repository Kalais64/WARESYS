import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        // Fetch user role after successful login
        final role = await _authService.getUserRole();
      if (mounted) {
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: Stack(
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  'assets/warehouse_bg.jpg',
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
                ),
                Container(
                  height: 220,
                  width: double.infinity,
                  color: const Color(0xCC176B4D), // semi-transparent green overlay
                ),
              ],
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: screenHeight - 40,
                  maxWidth: 430,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Icon(Icons.more_horiz, color: Colors.white, size: 28),
                        ],
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 4, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hallo',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Perintis',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF176B4D),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _roundedInputDecoration('Youremail@gmail.com'),
                                    style: const TextStyle(fontSize: 15),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                  ),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: _roundedInputDecoration('Password'),
                                    style: const TextStyle(fontSize: 15),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _rememberMe,
                                            activeColor: const Color(0xFF1DE9B6),
                                            onChanged: (val) {
                                              setState(() {
                                                _rememberMe = val ?? false;
                                              });
                                            },
                                          ),
                                          const Text('Remember me', style: TextStyle(color: Color(0xFF1DE9B6), fontSize: 13)),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text('Forgot Password?', style: TextStyle(color: Colors.black87, fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF176B4D),
                                        side: const BorderSide(color: Color(0xFF176B4D), width: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: _isLoading ? null : _login,
                                      child: _isLoading
                                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF176B4D)))
                                          : const Text('LOGIN'),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text('Atau masuk dengan', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _socialButton('assets/google.svg'),
                                      const SizedBox(width: 16),
                                      _socialButton('assets/apple.svg'),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  const Text('Belum punya akun?', style: TextStyle(color: Colors.black54, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF176B4D),
                                        side: const BorderSide(color: Color(0xFF176B4D), width: 2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/register');
                                      },
                                      child: const Text('Daftar Sekarang'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 4),
                                  const Text.rich(
                                    TextSpan(
                                      text: 'By logging in or using another login method, i agree with ',
                                      style: TextStyle(fontSize: 10, color: Colors.black54),
                                      children: [
                                        TextSpan(
                                          text: 'Terms & Conditions and Privacy Policy',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF176B4D)),
                                        ),
                                        TextSpan(
                                          text: ' from ',
                                        ),
                                        TextSpan(
                                          text: 'Waresys',
                                          style: TextStyle(color: Color(0xFF176B4D)),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  InputDecoration _roundedInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Color(0xFF176B4D), width: 2),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SvgPicture.asset(
        assetPath,
        height: 32,
        width: 32,
      ),
    );
  }
}
