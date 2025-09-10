import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adminCodeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRole = 'user';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _adminCodeController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Validasi kode admin jika role admin
    if (_selectedRole == 'admin') {
      if (_adminCodeController.text.trim() != 'waresysadmin') {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Kode admin salah!';
        });
        return;
      }
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Store name, company, and role in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'company': _companyController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                        padding: EdgeInsets.only(left: 16, top: 4),
                        child: Text(
                          'Hallo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 12),
                        child: Text(
                          'Perintis',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF176B4D),
                        ),
                      ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: _roundedInputDecoration('Your Name'),
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                      ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _roundedInputDecoration('Youremail@gmail.com'),
                                    style: const TextStyle(fontSize: 14),
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
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: const [
                                        Text('Company Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                        SizedBox(width: 4),
                                        Text('(Optional)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _companyController,
                                    decoration: _roundedInputDecoration('Waresys'),
                                    style: const TextStyle(fontSize: 14),
                      ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: _roundedInputDecoration('Password'),
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                      ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    decoration: _roundedInputDecoration('Confirm Password'),
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Role', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('User'),
                                          value: 'user',
                                          groupValue: _selectedRole,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRole = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Admin'),
                                          value: 'admin',
                                          groupValue: _selectedRole,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRole = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_selectedRole == 'admin')
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: TextFormField(
                                        controller: _adminCodeController,
                                        obscureText: true,
                                        decoration: _roundedInputDecoration('Masukkan Kode Admin'),
                                        validator: (value) {
                                          if (_selectedRole == 'admin' && (value == null || value.isEmpty)) {
                                            return 'Kode admin wajib diisi';
                                          }
                                          return null;
                                        },
                                      ),
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
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF176B4D),
                                        foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(32),
                          ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                                      onPressed: _isLoading ? null : _register,
                                      child: _isLoading
                                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                          : const Text('SIGN UP'),
                                    ),
                      ),
                                  const SizedBox(height: 10),
                                  const Text('Atau masuk dengan', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                                      _socialButton('assets/google.svg'),
                                      const SizedBox(width: 12),
                                      _socialButton('assets/apple.svg'),
                                    ],
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
        borderSide: BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: Color(0xFF176B4D), width: 2),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
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


