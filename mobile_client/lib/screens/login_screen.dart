import 'dart:math';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool isLogin = true;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final AnimationController _bgController;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // For login/signup toggle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // For background animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      isLogin = !isLogin;
      isLogin ? _controller.reverse() : _controller.forward();
    });
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _animatedBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        final sine = sin(_bgController.value * 2 * pi);
        return Stack(
          children: [
            Positioned(
              top: 100 + 30 * sine,
              left: 50 + 20 * sine,
              child: _blob(120, Colors.blueAccent.withOpacity(0.3)),
            ),
            Positioned(
              bottom: 80 + 40 * sine,
              right: 40 + 30 * sine,
              child: _blob(200, Colors.purpleAccent.withOpacity(0.25)),
            ),
            Positioned(
              bottom: 200,
              left: 100 + 20 * sine,
              child: _blob(100, Colors.lightBlue.withOpacity(0.2)),
            ),
          ],
        );
      },
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _animatedBackground(),
          Center(
            child: SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(24),
                width: size.width > 500 ? 400 : size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500),
                      crossFadeState: isLogin
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      secondChild: const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      hintText: 'Email',
                      icon: Icons.email,
                      controller: _emailController,
                    ),
                    _buildTextField(
                      hintText: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    SizeTransition(
                      sizeFactor: _animation,
                      axisAlignment: -1.0,
                      child: isLogin
                          ? const SizedBox()
                          : _buildTextField(
                        hintText: 'Confirm Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: TextEditingController(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Handle login/signup logic
                      },
                      child: Text(isLogin ? 'Login' : 'Sign Up'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: toggleView,
                      child: Text(
                        isLogin
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Login",
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
}
