import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MindSpaceColors.gradientStart,
              MindSpaceColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder:
                (context, constraints) => Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            constraints.maxWidth < 600
                                ? constraints.maxWidth
                                : 500,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildLoginForm(),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: MindSpaceColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildForm(),
          const SizedBox(height: 24),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: MindSpaceColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.psychology_outlined,
            size: 40,
            color: MindSpaceColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.welcomeMessage,
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.loginSubtitle,
          style: AppTextStyles.body2.copyWith(color: MindSpaceColors.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: "Username",
            controller: _usernameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
            prefixIcon: const Icon(
              Icons.person_outline,
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
          const SizedBox(height: 24),
          CustomButton(
            text: AppStrings.signIn,
            onPressed: _handleEmailLogin,
            isLoading: ref.watch(authStatusProvider) == AuthStatus.loading,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.signup);
          },
          child: RichText(
            text: TextSpan(
              text: AppStrings.dontHaveAccount,
              style: AppTextStyles.body2.copyWith(
                color: MindSpaceColors.textLight,
              ),
              children: [
                TextSpan(
                  text: AppStrings.signUp,
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

  void _handleEmailLogin() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authNotifierProvider.notifier);

      try {
        final response = await authNotifier.login(
          _usernameController.text.trim(),
          _passwordController.text,
        );

        if (mounted && response.success) {
          // Navigate to dashboard on success
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        } else if (mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
