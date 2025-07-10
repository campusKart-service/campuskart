import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../utils/auth_service.dart';
import '../../../utils/email_verification_service.dart';

class EmailVerificationWidget extends StatefulWidget {
  final String? selectedCampus;
  final List<Map<String, dynamic>> campusList;
  final String verificationStatus;
  final Function(String email, String status) onEmailVerified;

  const EmailVerificationWidget({
    Key? key,
    required this.selectedCampus,
    required this.campusList,
    required this.verificationStatus,
    required this.onEmailVerified,
  }) : super(key: key);

  @override
  State<EmailVerificationWidget> createState() =>
      _EmailVerificationWidgetState();
}

class _EmailVerificationWidgetState extends State<EmailVerificationWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final EmailVerificationService _emailService = EmailVerificationService();
  final AuthService _authService = AuthService();

  bool _isCodeSent = false;
  bool _isLoading = false;
  bool _isVerifying = false;
  String? _emailError;
  String? _codeError;
  int _resendCountdown = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
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

  void _onEmailChanged(String value) {
    setState(() {
      _emailError = _validateEmail(value);
    });
  }

  void _onCodeChanged(String value) {
    setState(() {
      _codeError = null;
    });
  }

  String? _getCampusDomain() {
    if (widget.selectedCampus == null) return null;

    final campus = widget.campusList.firstWhere(
      (campus) => campus['name'] == widget.selectedCampus,
      orElse: () => {},
    );

    return campus['domain'];
  }

  Future<void> _sendVerificationCode() async {
    final email = _emailController.text.trim();
    final emailError = _validateEmail(email);

    if (emailError != null) {
      setState(() {
        _emailError = emailError;
      });
      return;
    }

    // Check if email domain matches selected campus
    final campusDomain = _getCampusDomain();
    if (campusDomain != null && !email.endsWith('@$campusDomain')) {
      setState(() {
        _emailError =
            'Email must be from ${widget.selectedCampus} domain (@$campusDomain)';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
    });

    try {
      // Get current user from auth
      final user = _authService.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Send verification email
      final result = await _emailService.sendVerificationEmail(
        email: email,
        userId: user.id,
      );

      if (result['success'] == true) {
        setState(() {
          _isCodeSent = true;
          _resendCountdown = 60;
        });

        _startResendCountdown();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification code sent to $email'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception(
            result['message'] ?? 'Failed to send verification code');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification code: $error'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyCode() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _codeError = 'Verification code is required';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _codeError = null;
    });

    try {
      // Get current user from auth
      final user = _authService.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Verify email with token
      final result = await _emailService.verifyEmail(
        userId: user.id,
        token: code,
      );

      if (result['success'] == true) {
        widget.onEmailVerified(_emailController.text.trim(), 'verified');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        setState(() {
          _codeError =
              result['message'] ?? 'Invalid or expired verification code';
        });
      }
    } catch (error) {
      setState(() {
        _codeError = 'Verification failed: $error';
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendCode() async {
    if (_resendCountdown > 0) return;

    try {
      final user = _authService.getCurrentUser();
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _emailService.resendVerificationEmail(
        email: _emailController.text.trim(),
        userId: user.id,
      );

      setState(() {
        _resendCountdown = 60;
      });

      _startResendCountdown();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code resent'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend code: $error'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final campusDomain = _getCampusDomain();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: widget.verificationStatus == 'verified'
              ? AppTheme.lightTheme.colorScheme.tertiary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: widget.verificationStatus == 'verified'
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: widget.verificationStatus == 'verified'
                      ? 'verified'
                      : 'email',
                  color: widget.verificationStatus == 'verified'
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email Verification',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.verificationStatus == 'verified'
                          ? 'Email verified successfully'
                          : campusDomain != null
                              ? 'Enter your @$campusDomain email'
                              : 'Verify your email address',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.verificationStatus == 'verified')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    'Verified',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          if (widget.verificationStatus != 'verified') ...[
            SizedBox(height: 3.h),

            // Email input field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  enabled: !_isCodeSent,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onChanged: _onEmailChanged,
                  decoration: InputDecoration(
                    labelText: campusDomain != null
                        ? 'Email Address'
                        : 'Email Address',
                    hintText: campusDomain != null
                        ? 'your.name@$campusDomain'
                        : 'your.email@gmail.com',
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
            ),

            if (_isCodeSent) ...[
              SizedBox(height: 2.h),

              // Verification code input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: _onCodeChanged,
                    decoration: InputDecoration(
                      labelText: 'Verification Code',
                      hintText: 'Enter the code sent to your email',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'pin',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ),
                      errorText: null,
                    ),
                  ),
                  if (_codeError != null) ...[
                    SizedBox(height: 0.5.h),
                    Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: Text(
                        _codeError!,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 1.h),

              // Resend code link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resendCountdown > 0 ? null : _resendCode,
                  child: Text(
                    _resendCountdown > 0
                        ? 'Resend in ${_resendCountdown}s'
                        : 'Resend Code',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _resendCountdown > 0
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // Action button
            SizedBox(
              width: double.infinity,
              height: 5.h,
              child: ElevatedButton(
                onPressed: (_isLoading || _isVerifying)
                    ? null
                    : _isCodeSent
                        ? _verifyCode
                        : _sendVerificationCode,
                child: (_isLoading || _isVerifying)
                    ? SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isCodeSent ? 'Verify Code' : 'Send Verification Code',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
