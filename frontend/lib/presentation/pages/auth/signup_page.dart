import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF084879),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF084879), Color(0xFF215F99), Color(0xFF4287CD)],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child:
                  isLargeScreen
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 40,
                                top: 40,
                              ),
                              child: _buildLeftContent(),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: SingleChildScrollView(
                                child: _buildSignupForm(context),
                              ),
                            ),
                          ),
                        ],
                      )
                      : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLeftContent(),
                            const SizedBox(height: 40),
                            _buildSignupForm(context),
                          ],
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join MindSpace',
          style: AppTextStyles.h1.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Create your account to get started',
          style: AppTextStyles.body1.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 38),
        _buildFeature(
          'Step into a safe space — your identity stays hidden.',
          Icons.visibility_off,
        ),
        _buildFeature(
          'Track your moods, reflect daily, and watch your journey unfold.',
          Icons.pie_chart_outline,
        ),
        _buildFeature(
          'Share, support, and heal together — anonymously.',
          Icons.favorite_outline,
        ),
        const SizedBox(height: 48),
        Text(
          '"Happiness depends upon ourselves" – Aristotle',
          style: AppTextStyles.h4.copyWith(
            color: Colors.white.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.93), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body1.copyWith(
                color: Colors.white.withOpacity(0.93),
                height: 1.35,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 540),
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 30,
            offset: const Offset(0, 17),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormFields(),
          const SizedBox(height: 30),
          CustomButton(
            text: AppStrings.signUp,
            onPressed: _handleSignup,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 18),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: AppStrings.fullName,
            controller: _nameController,
            validator: Validators.validateName,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: MindSpaceColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: MindSpaceColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.password,
            controller: _passwordController,
            isPassword: true,
            validator: Validators.validatePassword,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: MindSpaceColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: AppStrings.confirmPassword,
            controller: _confirmPasswordController,
            isPassword: true,
            validator:
                (value) => Validators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: MindSpaceColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: RichText(
            text: TextSpan(
              text: AppStrings.alreadyHaveAccount,
              style: AppTextStyles.body2.copyWith(
                color: MindSpaceColors.textLight,
              ),
              children: [
                TextSpan(
                  text: AppStrings.signIn,
                  style: AppTextStyles.body2.copyWith(
                    color: MindSpaceColors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.privacyText,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      // TODO: integrate backend signup
    }
  }
}
