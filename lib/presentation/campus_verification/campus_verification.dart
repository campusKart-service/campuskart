import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/campus_selection_widget.dart';
import './widgets/email_verification_widget.dart';
import './widgets/id_upload_widget.dart';
import './widgets/progress_indicator_widget.dart';

class CampusVerification extends StatefulWidget {
  const CampusVerification({Key? key}) : super(key: key);

  @override
  State<CampusVerification> createState() => _CampusVerificationState();
}

class _CampusVerificationState extends State<CampusVerification> {
  String? selectedCampus;
  bool isIdUploaded = false;
  bool isEmailVerified = false;
  bool isLoading = false;
  String? uploadedIdPath;
  String? verificationEmail;
  String emailVerificationStatus = 'pending'; // pending, verified, failed

  final List<Map<String, dynamic>> campusList = [
    {
      "id": 1,
      "name": "Harvard University",
      "domain": "harvard.edu",
      "location": "Cambridge, MA"
    },
    {
      "id": 2,
      "name": "Stanford University",
      "domain": "stanford.edu",
      "location": "Stanford, CA"
    },
    {"id": 3, "name": "MIT", "domain": "mit.edu", "location": "Cambridge, MA"},
    {
      "id": 4,
      "name": "University of California, Berkeley",
      "domain": "berkeley.edu",
      "location": "Berkeley, CA"
    },
    {
      "id": 5,
      "name": "Yale University",
      "domain": "yale.edu",
      "location": "New Haven, CT"
    },
    {
      "id": 6,
      "name": "Princeton University",
      "domain": "princeton.edu",
      "location": "Princeton, NJ"
    },
    {
      "id": 7,
      "name": "Columbia University",
      "domain": "columbia.edu",
      "location": "New York, NY"
    },
    {
      "id": 8,
      "name": "University of Chicago",
      "domain": "uchicago.edu",
      "location": "Chicago, IL"
    }
  ];

  void _onCampusSelected(String campus) {
    setState(() {
      selectedCampus = campus;
    });
  }

  void _onIdUploaded(String imagePath) {
    setState(() {
      isIdUploaded = true;
      uploadedIdPath = imagePath;
    });
    HapticFeedback.lightImpact();
  }

  void _onEmailVerified(String email, String status) {
    setState(() {
      verificationEmail = email;
      emailVerificationStatus = status;
      isEmailVerified = status == 'verified';
    });
    if (status == 'verified') {
      HapticFeedback.mediumImpact();
    }
  }

  void _handleContinue() {
    if (selectedCampus != null && isIdUploaded && isEmailVerified) {
      setState(() {
        isLoading = true;
      });

      // Simulate processing delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamed(context, '/home-screen');
        }
      });
    }
  }

  void _handleSkip() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Skip Verification?',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            'You can complete verification later in your profile settings. Some features may be limited.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home-screen');
              },
              child: const Text('Skip'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue =
        selectedCampus != null && isIdUploaded && isEmailVerified;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress and skip option
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ProgressIndicatorWidget(
                      currentStep: 2,
                      totalSteps: 3,
                    ),
                  ),
                  TextButton(
                    onPressed: _handleSkip,
                    child: Text(
                      'Skip for Now',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Title and description
                    Text(
                      'Verify Your Campus',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Connect with your campus community by verifying your student status. This helps ensure a safe marketplace for everyone.',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Campus selection
                    CampusSelectionWidget(
                      campusList: campusList,
                      selectedCampus: selectedCampus,
                      onCampusSelected: _onCampusSelected,
                    ),
                    SizedBox(height: 3.h),

                    // ID upload section
                    IdUploadWidget(
                      isUploaded: isIdUploaded,
                      uploadedImagePath: uploadedIdPath,
                      onIdUploaded: _onIdUploaded,
                    ),
                    SizedBox(height: 3.h),

                    // Email verification section
                    EmailVerificationWidget(
                      selectedCampus: selectedCampus,
                      campusList: campusList,
                      verificationStatus: emailVerificationStatus,
                      onEmailVerified: _onEmailVerified,
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),

            // Bottom continue button
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: canContinue && !isLoading ? _handleContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canContinue
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    foregroundColor: canContinue
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    elevation: canContinue ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Continue',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: canContinue
                                ? Colors.white
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
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
