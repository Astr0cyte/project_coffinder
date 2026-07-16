import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/mascot_avatar.dart';
import '../widgets/top_gradient_backdrop.dart';
import 'password_reset_confirm_page.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({
    super.key,
    required this.email,
    this.onVerify,
    this.onResend,
  });

  final String email;

  /// Called with the 5-digit code when the user taps "Verify Code". If
  /// null, defaults to pushing [PasswordResetConfirmPage].
  final void Function(BuildContext context, String code)? onVerify;
  final VoidCallback? onResend;

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  static const _digitCount = 5;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _canSubmit = false;

  static const _textColor = Color(0xFF3E2A20);
  static const _backgroundColor = Color(0xFFFAF6EE);
  static const _buttonColor = Color(0xFF8A6A50);
  static const _edgeSpacing = 24.0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_digitCount, (_) => TextEditingController());
    _focusNodes = List.generate(_digitCount, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _updateCanSubmit() {
    setState(() => _canSubmit = _code.length == _digitCount);
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _digitCount - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _updateCanSubmit();
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleVerify(BuildContext context) {
    if (widget.onVerify != null) {
      widget.onVerify!(context, _code);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PasswordResetConfirmPage(),
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
                                'Check your email',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _textColor.withOpacity(0.7),
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                  ),
                                  children: [
                                    const TextSpan(text: 'We sent a reset link to '),
                                    TextSpan(
                                      text: widget.email,
                                      style: const TextStyle(
                                        color: _textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'enter 5 digit code that mentioned in the email',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _textColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(_digitCount, (index) {
                                  return SizedBox(
                                    width: 52,
                                    height: 56,
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _focusNodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: _textColor,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide:
                                          const BorderSide(color: Color(0xFFE3DACB)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide:
                                          const BorderSide(color: Color(0xFFE3DACB)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide:
                                          const BorderSide(color: _textColor),
                                        ),
                                      ),
                                      onChanged: (value) => _onDigitChanged(index, value),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                  _canSubmit ? () => _handleVerify(context) : null,
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
                                    'Verify Code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Haven't got the email yet? ",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _textColor.withOpacity(0.6),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onResend ?? () {},
                                      child: const Text(
                                        'Resend email',
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