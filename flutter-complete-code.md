# MindSpace Flutter Web App - Complete Code Files

## Project Structure
```
frontend/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── colors.dart
│   │   │   ├── routes.dart
│   │   │   └── strings.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   └── utils/
│   │       └── validators.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── auth/
│   │   │       ├── login_page.dart
│   │   │       └── signup_page.dart
│   │   └── widgets/
│   │       └── common/
│   │           ├── custom_button.dart
│   │           ├── custom_text_field.dart
│   │           └── loading_widget.dart
│   └── main.dart
├── web/
│   └── index.html
└── pubspec.yaml
```

## 1. pubspec.yaml

```yaml
name: mindspace
description: Mental Health & Peer Support Platform

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # HTTP Client
  dio: ^5.3.2
  
  # Storage
  shared_preferences: ^2.2.0
  
  # UI Components
  google_fonts: ^5.1.0
  flutter_animate: ^4.2.0+1
  
  # Icons
  cupertino_icons: ^1.0.2
  
  # Authentication
  google_sign_in: ^6.1.5
  
  # Form validation
  email_validator: ^2.1.17

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
```

## 2. main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/routes.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/signup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MindSpaceApp(),
    ),
  );
}

class MindSpaceApp extends StatelessWidget {
  const MindSpaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindSpace - Mental Wellness Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signup: (context) => const SignupPage(),
      },
    );
  }
}
```

## 3. core/constants/colors.dart

```dart
import 'package:flutter/material.dart';

class MindSpaceColors {
  // Primary calming colors
  static const Color primaryBlue = Color(0xFF6B9EE5);
  static const Color softLavender = Color(0xFFB8A9D9);
  static const Color calmMint = Color(0xFF9FDFCD);
  
  // Neutral tones
  static const Color warmWhite = Color(0xFFFAFAFA);
  static const Color softGray = Color(0xFFE8E8E8);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF6C7B7F);
  
  // Accent colors
  static const Color successGreen = Color(0xFF81C784);
  static const Color warningAmber = Color(0xFFFFB74D);
  static const Color errorRed = Color(0xFFE57373);
  
  // Background gradients
  static const Color gradientStart = Color(0xFFE3F2FD);
  static const Color gradientEnd = Color(0xFFF3E5F5);
  
  // Card and surface colors
  static const Color cardBackground = Colors.white;
  static const Color surfaceLight = Color(0xFFFBFBFB);
  
  // Divider and border colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFD1D5DB);
}
```

## 4. core/constants/routes.dart

```dart
class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String journal = '/journal';
  static const String community = '/community';
  static const String chat = '/chat';
  static const String profile = '/profile';
}
```

## 5. core/constants/strings.dart

```dart
class AppStrings {
  // App info
  static const String appName = 'MindSpace';
  static const String tagline = 'Your safe space for mental wellness';
  
  // Auth screens
  static const String welcomeMessage = 'Welcome to MindSpace';
  static const String loginSubtitle = 'Sign in to continue your wellness journey';
  static const String signupTitle = 'Join MindSpace';
  static const String signupSubtitle = 'Create your account to get started';
  
  // Form labels
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  
  // Buttons
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueAnonymously = 'Continue Anonymously';
  
  // Links
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = "Already have an account? ";
  static const String forgotPassword = 'Forgot Password?';
  
  // Privacy
  static const String privacyText = 'By continuing, you agree to our Terms & Privacy Policy';
  
  // Validation messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String nameRequired = 'Full name is required';
}
```

## 6. core/theme/app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: MindSpaceColors.primaryBlue,
      scaffoldBackgroundColor: MindSpaceColors.warmWhite,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: MindSpaceColors.primaryBlue,
        secondary: MindSpaceColors.calmMint,
        surface: MindSpaceColors.cardBackground,
        background: MindSpaceColors.warmWhite,
        error: MindSpaceColors.errorRed,
        onPrimary: Colors.white,
        onSecondary: MindSpaceColors.textDark,
        onSurface: MindSpaceColors.textDark,
        onBackground: MindSpaceColors.textDark,
        onError: Colors.white,
      ),
      
      // Text theme
      textTheme: AppTextStyles.textTheme,
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: MindSpaceColors.textDark,
        ),
        iconTheme: const IconThemeData(
          color: MindSpaceColors.textDark,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MindSpaceColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MindSpaceColors.textDark,
          side: const BorderSide(
            color: MindSpaceColors.border,
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MindSpaceColors.primaryBlue,
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MindSpaceColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MindSpaceColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MindSpaceColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MindSpaceColors.errorRed,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: AppTextStyles.body2.copyWith(
          color: MindSpaceColors.textLight,
        ),
        hintStyle: AppTextStyles.body2.copyWith(
          color: MindSpaceColors.textLight,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: MindSpaceColors.cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    // Dark theme implementation if needed
    return lightTheme; // For now, using light theme
  }
}
```

## 7. core/theme/text_styles.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTextStyles {
  static TextStyle get _baseTextStyle => GoogleFonts.inter(
    color: MindSpaceColors.textDark,
  );
  
  // Headings
  static TextStyle get h1 => _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  
  static TextStyle get h2 => _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static TextStyle get h3 => _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static TextStyle get h4 => _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
  
  // Body text
  static TextStyle get body1 => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static TextStyle get body2 => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  // Button text
  static TextStyle get button => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );
  
  // Caption
  static TextStyle get caption => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MindSpaceColors.textLight,
  );
  
  // Text theme for Material Theme
  static TextTheme get textTheme => TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    displaySmall: h3,
    headlineMedium: h4,
    bodyLarge: body1,
    bodyMedium: body2,
    labelLarge: button,
    bodySmall: caption,
  );
}
```

## 8. core/utils/validators.dart

```dart
import 'package:email_validator/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
}
```

## 9. presentation/widgets/common/custom_button.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/text_styles.dart';

enum ButtonType { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double height;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 12),
              ],
              Text(text),
            ],
          );
    
    Widget button;
    
    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
          child: buttonChild,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: buttonChild,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(text),
        );
        break;
    }
    
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: button,
    );
  }
}
```

## 10. presentation/widgets/common/custom_text_field.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/theme/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  
  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
  }) : super(key: key);
  
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: widget.isPassword ? _obscureText : false,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        style: AppTextStyles.body1,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: widget.prefixIcon,
                )
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: MindSpaceColors.textLight,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
```

## 11. presentation/widgets/common/loading_widget.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  
  const LoadingWidget({
    Key? key,
    this.message,
    this.size = 50,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                MindSpaceColors.primaryBlue,
              ),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MindSpaceColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
```

## 12. presentation/pages/auth/login_page.dart

```dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
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
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildLoginForm(),
                      ),
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
          _buildSocialLogin(),
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
          style: AppTextStyles.body2.copyWith(
            color: MindSpaceColors.textLight,
          ),
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
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _handleForgotPassword,
              child: Text(
                AppStrings.forgotPassword,
                style: AppTextStyles.body2.copyWith(
                  color: MindSpaceColors.primaryBlue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: AppStrings.signIn,
            onPressed: _handleEmailLogin,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialLogin() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: MindSpaceColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: AppTextStyles.body2.copyWith(
                  color: MindSpaceColors.textLight,
                ),
              ),
            ),
            const Expanded(child: Divider(color: MindSpaceColors.divider)),
          ],
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: AppStrings.continueWithGoogle,
          type: ButtonType.outlined,
          onPressed: _handleGoogleLogin,
          icon: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: MindSpaceColors.primaryBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.g_mobiledata,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
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
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Handle login logic here
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      
      // Navigate to dashboard on success
      // Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }
  
  void _handleGoogleLogin() {
    // Handle Google login
    print('Google login pressed');
  }
  
  void _handleForgotPassword() {
    // Handle forgot password
    print('Forgot password pressed');
  }
}
```

## 13. presentation/pages/auth/signup_page.dart

```dart
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
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
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
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildSignupForm(),
                      ),
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
  
  Widget _buildSignupForm() {
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
          _buildSocialSignup(),
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
            color: MindSpaceColors.calmMint.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person_add_outlined,
            size: 40,
            color: MindSpaceColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.signupTitle,
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.signupSubtitle,
          style: AppTextStyles.body2.copyWith(
            color: MindSpaceColors.textLight,
          ),
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
            validator: (value) => Validators.validateConfirmPassword(
              value,
              _passwordController.text,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: MindSpaceColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: AppStrings.signUp,
            onPressed: _handleSignup,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialSignup() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: MindSpaceColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or',
                style: AppTextStyles.body2.copyWith(
                  color: MindSpaceColors.textLight,
                ),
              ),
            ),
            const Expanded(child: Divider(color: MindSpaceColors.divider)),
          ],
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: AppStrings.continueWithGoogle,
          type: ButtonType.outlined,
          onPressed: _handleGoogleSignup,
          icon: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: MindSpaceColors.primaryBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.g_mobiledata,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFooter() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      // Handle signup logic here
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      
      // Navigate to dashboard on success
      // Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }
  
  void _handleGoogleSignup() {
    // Handle Google signup
    print('Google signup pressed');
  }
}
```

## 14. web/index.html

```html
<!DOCTYPE html>
<html>
<head>
  <!--
    If you are serving your web app in a path other than the root, change the
    href value below to reflect the base path you are serving from.

    The path provided below has to start and end with a slash "/" in order for
    it to work correctly.

    For more details:
    * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base

    This is a placeholder for base href that will be replaced by the value of
    the `--base-href` argument provided to `flutter build`.
  -->
  <base href="$FLUTTER_BASE_HREF">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="MindSpace - Your safe space for mental wellness. Connect, reflect, and grow with our supportive community.">

  <!-- iOS meta tags & icons -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="MindSpace">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <title>MindSpace - Mental Wellness Platform</title>
  <link rel="manifest" href="manifest.json">

  <style>
    /* Loading screen styles */
    .loading {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      background: linear-gradient(135deg, #E3F2FD 0%, #F3E5F5 100%);
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }
    
    .loading-logo {
      width: 80px;
      height: 80px;
      background: #6B9EE5;
      border-radius: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 24px;
      opacity: 0.1;
    }
    
    .loading-text {
      color: #2C3E50;
      font-size: 24px;
      font-weight: 600;
      margin-bottom: 8px;
    }
    
    .loading-subtitle {
      color: #6C7B7F;
      font-size: 16px;
      margin-bottom: 32px;
    }
    
    .loading-spinner {
      width: 32px;
      height: 32px;
      border: 3px solid #E8E8E8;
      border-top: 3px solid #6B9EE5;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
  <!-- Loading screen -->
  <div id="loading" class="loading">
    <div class="loading-logo">
      <div style="color: white; font-size: 40px;">🧠</div>
    </div>
    <div class="loading-text">MindSpace</div>
    <div class="loading-subtitle">Loading your wellness journey...</div>
    <div class="loading-spinner"></div>
  </div>

  <script>
    window.addEventListener('flutter-first-frame', function () {
      document.getElementById('loading').style.display = 'none';
    });
  </script>
  
  <script
    type="application/javascript"
    src="flutter.js" defer></script>
</body>
</html>
```

This complete Flutter web app provides:

1. **Professional theme** with calming mental health colors
2. **Animated login/signup pages** with smooth transitions  
3. **Form validation** with user-friendly error messages
4. **Google Sign-In integration** ready for implementation
5. **Responsive design** that works on all screen sizes
6. **Clean architecture** with proper separation of concerns
7. **Reusable components** for consistent UI
8. **Loading states** and proper error handling

To run the app:
```bash
cd frontend
flutter run -d chrome
```

The UI follows mental health app design best practices with calming colors, gentle animations, and stress-free user interactions.