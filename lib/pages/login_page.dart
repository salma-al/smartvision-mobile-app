import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    // Automatic sign in - navigate to home page
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECEF),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                // Logo
                Image.asset(
                  'assets/icons/SVEC_logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                // Welcome Text and Subtitle - aligned to left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 36 / 24,
                          color: AppColors.darkText,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to access your account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightText,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'your.email@company.com',
                          hintStyle: TextStyle(
                            color: AppColors.helperText,
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkText,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: AppColors.helperText,
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.lightText,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkText,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                    // Remember Me
                    Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-8, 0), // shifts checkbox left to align perfectly
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: AppColors.svecColor,
                            side: BorderSide(color: AppColors.lightText),
                          ),
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkText,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.svecColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Contact Administrator
                Text(
                  'Need access? Contact your administrator',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.helperText,
                    fontFamily: 'DM Sans',
                  ),
                  textAlign: TextAlign.center,
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
}

