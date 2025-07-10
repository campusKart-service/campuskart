import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../utils/auth_service.dart';
import '../../utils/email_verification_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final EmailVerificationService _emailService = EmailVerificationService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptedTerms = false;

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _acceptedTerms;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onFullNameChanged(String value) {
    setState(() {
      _fullNameError = _validateFullName(value);
    });
  }

  void _onEmailChanged(String value) {
    setState(() {
      _emailError = _validateEmail(value);
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordError = _validatePassword(value);
      // Re-validate confirm password if it's been entered
      if (_confirmPasswordController.text.isNotEmpty) {
        _confirmPasswordError =
            _validateConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _confirmPasswordError = _validateConfirmPassword(value);
    });
  }

  Future<void> _handleSignUp() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (response.user != null && mounted) {
        // Success - trigger haptic feedback
        HapticFeedback.lightImpact();

        // Send verification email
        try {
          await _emailService.sendVerificationEmail(
            email: email,
            userId: response.user!.id,
          );
        } catch (verificationError) {
          // Non-critical error - user is created but verification email failed
          debugPrint('Verification email failed: $verificationError');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Account created successfully! Please verify your email.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to campus verification
        Navigator.pushReplacementNamed(context, '/campus-verification');
      }
    } catch (error) {
      if (mounted) {
        String errorMessage = 'Registration failed. Please try again.';

        if (error.toString().contains('User already registered')) {
          errorMessage = 'An account with this email already exists.';
        } else if (error.toString().contains('Invalid email')) {
          errorMessage = 'Please enter a valid email address.';
        } else if (error
            .toString()
            .contains('Password should be at least 6 characters')) {
          errorMessage = 'Password must be at least 6 characters long.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSignIn() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 6.h),

                // Logo
                _buildLogo(),

                SizedBox(height: 4.h),

                // Welcome Text
                _buildWelcomeText(),

                SizedBox(height: 4.h),

                // Full Name Field
                _buildFullNameField(),

                SizedBox(height: 2.h),

                // Email Field
                _buildEmailField(),

                SizedBox(height: 2.h),

                // Password Field
                _buildPasswordField(),

                SizedBox(height: 2.h),

                // Confirm Password Field
                _buildConfirmPasswordField(),

                SizedBox(height: 2.h),

                // Terms and Conditions Checkbox
                _buildTermsCheckbox(),

                SizedBox(height: 4.h),

                // Sign Up Button
                _buildSignUpButton(),

                SizedBox(height: 3.h),

                // Security Badge
                _buildSecurityBadge(),

                SizedBox(height: 4.h),

                // Sign In Link
                _buildSignInLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(4.w),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'shopping_bag',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'CK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Create Account',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),
        Text(
          'Join your campus marketplace community',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _fullNameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          onChanged: _onFullNameChanged,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'John Doe',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: null,
          ),
        ),
        if (_fullNameError != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              _fullNameError!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: _onEmailChanged,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'your.email@gmail.com',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: null,
          ),
        ),
        if (_emailError != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              _emailError!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.next,
          onChanged: _onPasswordChanged,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: null,
          ),
        ),
        if (_passwordError != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              _passwordError!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
          onChanged: _onConfirmPasswordChanged,
          onFieldSubmitted: (_) => _handleSignUp(),
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              icon: CustomIconWidget(
                iconName:
                    _isConfirmPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            errorText: null,
          ),
        ),
        if (_confirmPasswordError != null) ...[
          SizedBox(height: 0.5.h),
          Padding(
            padding: EdgeInsets.only(left: 3.w),
            child: Text(
              _confirmPasswordError!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptedTerms,
          onChanged: (value) {
            setState(() {
              _acceptedTerms = value ?? false;
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptedTerms = !_acceptedTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading || !_isFormValid ? null : _handleSignUp,
        child: _isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'security',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Flexible(
            child: Text(
              'Your data is secure and encrypted',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: _handleSignIn,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign In',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
