import 'package:flutter/material.dart';
import '../states/sign_in_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
    this.onSubmit,
    this.onForgotPassword,
    this.onGoogleSignIn,
    this.onFacebookSignIn,
    this.onSignUp,
  });

  /// Called with email/password when the user taps "Log In".
  final void Function(String email, String password)? onSubmit;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoogleSignIn;
  final VoidCallback? onFacebookSignIn;
  final VoidCallback? onSignUp;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final SignInState _state;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  static const _textColor = Color(0xFF3E2A20);
  static const _backgroundColor = Color(0xFFFAF6EE);
  static const _buttonColor = Color(0xFF8A6A50);

  @override
  void initState() {
    super.initState();
    _state = SignInState();
    _emailController = TextEditingController()
      ..addListener(() => _state.setEmail(_emailController.text));
    _passwordController = TextEditingController()
      ..addListener(() => _state.setPassword(_passwordController.text));
    _state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogIn() {
    widget.onSubmit?.call(_state.email, _state.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // Logo / avatar
                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3ECE1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.coffee,
                              color: _textColor,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Sign in to your Account',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your email and password to log in',
                          style: TextStyle(
                            fontSize: 13,
                            color: _textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          controller: _emailController,
                          hintText: 'Loisbecket@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          controller: _passwordController,
                          hintText: '••••••••',
                          obscureText: _state.obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _state.obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _textColor.withOpacity(0.5),
                            ),
                            onPressed: _state.toggleObscurePassword,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _state.rememberMe,
                                    onChanged: (value) =>
                                        _state.toggleRememberMe(value),
                                    activeColor: _buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _textColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: widget.onForgotPassword,
                              child: const Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _state.canSubmit ? _handleLogIn : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColor,
                              disabledBackgroundColor: _buttonColor.withOpacity(0.5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Divider(color: _textColor.withOpacity(0.15))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'Or',
                                style: TextStyle(color: _textColor.withOpacity(0.5)),
                              ),
                            ),
                            Expanded(child: Divider(color: _textColor.withOpacity(0.15))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SocialLoginButton(
                          label: 'Continue with Google',
                          icon: const GoogleGlyph(),
                          onPressed: widget.onGoogleSignIn ?? () {},
                        ),
                        const SizedBox(height: 12),
                        SocialLoginButton(
                          label: 'Continue with Facebook',
                          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 22),
                          onPressed: widget.onFacebookSignIn ?? () {},
                        ),
                        const SizedBox(height: 28),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _textColor.withOpacity(0.6),
                                ),
                              ),
                              GestureDetector(
                                onTap: widget.onSignUp,
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}