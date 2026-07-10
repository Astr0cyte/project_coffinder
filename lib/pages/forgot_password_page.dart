import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/mascot_avatar.dart';
import '../widgets/top_gradient_backdrop.dart';
import 'verify_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    super.key,
    this.onSubmit,
  });

  /// Called with the email when the user taps "Reset Password". If null,
  /// defaults to pushing [VerifyCodePage] with that email.
  final void Function(BuildContext context, String email)? onSubmit;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController;
  bool _canSubmit = false;

  static const _textColor = Color(0xFF3E2A20);
  static const _backgroundColor = Color(0xFFFAF6EE);
  static const _buttonColor = Color(0xFF8A6A50);
  static const _edgeSpacing = 24.0;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()
      ..addListener(() {
        setState(() => _canSubmit = _emailController.text.trim().isNotEmpty);
      });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleSubmit(BuildContext context) {
    final email = _emailController.text.trim();
    if (widget.onSubmit != null) {
      widget.onSubmit!(context, email);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VerifyCodePage(email: email),
        ),
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
              child: TopGradientBackdrop(height: 160),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: _edgeSpacing + 44),
                              Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  padding: const EdgeInsets.all(8),
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
                                        return const MascotAvatar(size: 60);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Forgot password',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Please enter your email to reset the password',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _textColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Your Email',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AuthTextField(
                                controller: _emailController,
                                hintText: 'Enter your email',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                  _canSubmit ? () => _handleSubmit(context) : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonColor,
                                    disabledBackgroundColor:
                                    _buttonColor.withOpacity(0.5),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 60),
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