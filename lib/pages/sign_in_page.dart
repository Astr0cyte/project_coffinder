import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../states/sign_in_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_button.dart';
import '../widgets/mascot_avatar.dart';
import '../widgets/top_gradient_backdrop.dart';
import '../pages/login_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

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
  static const _edgeSpacing = 24.0;

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

  /// Goes back to LoginPage. If SignInPage was pushed on top of it (the
  /// normal case), a simple pop returns there. If for some reason there's
  /// nothing to pop to (e.g. SignInPage was opened as the first route),
  /// falls back to pushing LoginPage explicitly.
  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopGradientBackdrop(height: 220),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              SizedBox(height: _edgeSpacing + 44),
                              Center(
                                child: Container(
                                  width: 99,
                                  height: 99,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE6D8),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFC9B892),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/logo.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Falls back to the drawn mascot only if the
                                        // asset fails to load.
                                        return const MascotAvatar(size: 72);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Sign in to your\nAccount',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                  letterSpacing: 1,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter your email and password to log in',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _textColor.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 24),
                              AuthTextField(
                                controller: _emailController,
                                hintText: 'youremail@gmail.com',
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: _textColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: widget.onForgotPassword ??
                                            () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const ForgotPasswordPage(),
                                          ),
                                        ),
                                    child: const Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF375DFB),
                                        fontWeight: FontWeight.bold,
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
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFDFD9B9)),
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
                                icon: const GoogleLogoIcon(),
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _textColor.withOpacity(0.6),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onSignUp ??
                                              () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                              const RegisterPage(),
                                            ),
                                          ),
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF375DFB),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: _edgeSpacing),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: _edgeSpacing,
                  ),
                  child: Material(
                    color: Colors.white.withOpacity(0.5),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => _handleBack(context),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.arrow_back, color: _textColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}