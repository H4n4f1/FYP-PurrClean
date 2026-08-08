import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_styles.dart';
import '../widgets/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _fullNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();

  // 👇 This is the ONLY line you need to change once your backend is ready.
  // e.g. final AuthService _authService = ApiAuthService();
  final AuthService _authService = MockAuthService();

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _fullNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final result = await _authService.login(
      email: _loginEmailController.text.trim(),
      password: _loginPasswordController.text,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result.success) {
      // TODO: Navigate to your home/dashboard screen and store result.token.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Login failed')),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!_registerFormKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final result = await _authService.register(
      fullName: _fullNameController.text.trim(),
      email: _registerEmailController.text.trim(),
      password: _registerPasswordController.text,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please sign in.')),
      );
      setState(() => isLogin = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppDecorations.cardRadius,
              boxShadow: AppDecorations.cardShadow,
            ),
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildToggle(),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: isLogin
                            ? _buildLoginForm(key: const ValueKey('login'))
                            : _buildRegisterForm(
                                key: const ValueKey('register'),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.headerIconBg,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png', //logo image
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('PurrClean', style: AppTextStyles.appTitle),
                const SizedBox(height: 8),
                const Text(
                  'Smart Litter Box Monitoring',
                  style: AppTextStyles.appSubtitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.toggleTrack,
        borderRadius: AppDecorations.toggleRadius,
      ),
      child: Row(
        children: [
          Expanded(child: _toggleButton('Login', isLogin)),
          Expanded(child: _toggleButton('Register', !isLogin)),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => isLogin = label == 'Login'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: selected ? AppColors.primaryGradient : null,
          borderRadius: AppDecorations.toggleButtonRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: selected
              ? AppTextStyles.toggleLabelActive
              : AppTextStyles.toggleLabelInactive,
        ),
      ),
    );
  }

  Widget _buildLoginForm({Key? key}) {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: key,
        children: [
          CustomTextField(
            label: 'Email',
            hint: 'you@example.com',
            icon: Icons.alternate_email,
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          CustomTextField(
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
            controller: _loginPasswordController,
            obscureText: true,
            validator: (v) =>
                (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),
          const SizedBox(height: 8),
          _buildSubmitButton('Sign In', _handleLogin),
          const SizedBox(height: 16),
          const Text(
            'Demo account: demo@purrclean.com / demo1234',
            style: AppTextStyles.helperText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm({Key? key}) {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: key,
        children: [
          CustomTextField(
            label: 'Full Name',
            hint: 'John Doe',
            icon: Icons.person_outline,
            controller: _fullNameController,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
          ),
          CustomTextField(
            label: 'Email',
            hint: 'you@example.com',
            icon: Icons.alternate_email,
            controller: _registerEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
          ),
          CustomTextField(
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
            controller: _registerPasswordController,
            obscureText: true,
            validator: (v) =>
                (v == null || v.length < 6) ? 'Min 6 characters' : null,
          ),
          const SizedBox(height: 8),
          _buildSubmitButton('Create Account', _handleRegister),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.buttonRadius,
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(label, style: AppTextStyles.buttonLabel),
      ),
    );
  }
}
