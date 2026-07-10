import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../states/register_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/mascot_avatar.dart';
import '../widgets/top_gradient_backdrop.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    this.onSubmit,
    this.onLogIn,
  });

  /// Called with the completed [RegisterState] when the user taps "Register".
  final void Function(RegisterState state)? onSubmit;
  final VoidCallback? onLogIn;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterState _state;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  static const _textColor = Color(0xFF3E2A20);
  static const _backgroundColor = Color(0xFFFAF6EE);
  static const _buttonColor = Color(0xFF8A6A50);
  static const _edgeSpacing = 24.0;

  @override
  void initState() {
    super.initState();
    _state = RegisterState();
    _firstNameController = TextEditingController()
      ..addListener(() => _state.setFirstName(_firstNameController.text));
    _lastNameController = TextEditingController()
      ..addListener(() => _state.setLastName(_lastNameController.text));
    _emailController = TextEditingController()
      ..addListener(() => _state.setEmail(_emailController.text));
    _dobController = TextEditingController();
    _phoneController = TextEditingController()
      ..addListener(() => _state.setPhone(_phoneController.text));
    _passwordController = TextEditingController()
      ..addListener(() => _state.setPassword(_passwordController.text));
    _state.addListener(_onStateChanged);
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) {
      _state.setDateOfBirth(picked);
      _dobController.text =
      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void _handleRegister() {
    widget.onSubmit?.call(_state);
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
                                        // Falls back to the drawn mascot only if
                                        // the asset fails to load.
                                        return const MascotAvatar(size: 72);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Create an account to continue!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _textColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 24),
                              AuthTextField(
                                controller: _firstNameController,
                                hintText: 'First name',
                              ),
                              const SizedBox(height: 12),
                              AuthTextField(
                                controller: _lastNameController,
                                hintText: 'Last name',
                              ),
                              const SizedBox(height: 12),
                              AuthTextField(
                                controller: _emailController,
                                hintText: 'youremail@gmail.com',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              AuthTextField(
                                controller: _dobController,
                                hintText: 'DD/MM/YYYY',
                                readOnly: true,
                                onTap: _pickDateOfBirth,
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: _textColor.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _PhoneField(
                                controller: _phoneController,
                                flagEmoji: _state.countryFlagEmoji,
                                dialCode: _state.countryDialCode,
                                onCountryTap: () {
                                  // Hook up a real country picker here if needed;
                                  // kept minimal since it's outside this form's scope.
                                },
                              ),
                              const SizedBox(height: 12),
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
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _state.canSubmit ? _handleRegister : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _buttonColor,
                                    disabledBackgroundColor:
                                    _buttonColor.withOpacity(0.5),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: const BorderSide(
                                        color: Color(0xFF7C6AE8),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: _textColor.withOpacity(0.6),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: widget.onLogIn ??
                                              () => _handleBack(context),
                                      child: const Text(
                                        'Log in',
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
                              const SizedBox(height: _edgeSpacing),
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

/// Country-code + phone number row: a small flag/dial-code pill on the
/// left, and a regular phone number field on the right — matches the
/// "🇺🇸 (454) 726-0592" row in the mockup.
class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.flagEmoji,
    required this.dialCode,
    required this.onCountryTap,
  });

  final TextEditingController controller;
  final String flagEmoji;
  final String dialCode;
  final VoidCallback onCountryTap;

  static const _borderColor = Color(0xFFE3DACB);
  static const _textColor = Color(0xFF3E2A20);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onCountryTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(flagEmoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                const Icon(Icons.expand_more, size: 16, color: _textColor),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AuthTextField(
            controller: controller,
            hintText: '$dialCode phone number',
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}