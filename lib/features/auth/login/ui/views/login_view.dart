import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive values
    final horizontalPadding = screenWidth * 0.06; // 6% of screen width
    final verticalSpacing = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo or icon at the top
                  Container(
                    width: screenWidth * 0.13, // Responsive width
                    height: screenWidth * 0.13, // Keep it square
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.black,
                      size: screenWidth * 0.07, // Responsive icon size
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 1.5),

                  // Title
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 0.5),

                  // Subtitle
                  Text(
                    'We happy to see you here again. Enter your email address and password',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // Responsive font size
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 2),

                  // Email field
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    context: context,
                  ),

                  SizedBox(height: verticalSpacing),

                  // Password field
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    context: context,
                  ),

                  SizedBox(height: verticalSpacing * 2),

                  // Login button
                  CustomButton(
                    text: 'Log In',
                    backgroundColor: AppColors.primary,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.homeView);
                    },
                    height: screenHeight * 0.065, // Responsive height
                    borderRadius: 12,
                  ),

                  // Forgot password
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.forgetPasswordView);
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: verticalSpacing * 0.5),

                  // Divider with OR
                  const CustomDivider(),

                  SizedBox(height: verticalSpacing),

                  // Register button
                  CustomButton(
                    text: 'Create an Account',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.registerView);
                    },
                    height: screenHeight * 0.065,
                    borderRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required BuildContext context,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightSecondary),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && !_isPasswordVisible,
        style: TextStyle(fontSize: screenWidth * 0.04, color: AppColors.text),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: screenWidth * 0.04,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.text.withValues(alpha: 0.7),
                      size: screenWidth * 0.055,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
