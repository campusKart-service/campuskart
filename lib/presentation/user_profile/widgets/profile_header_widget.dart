import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with verification badge
              Stack(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: userData["avatar"] as String,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (userData["isVerified"] == true)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'verified',
                          color: Colors.white,
                          size: 3.w,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 4.w),

              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userData["name"] as String,
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: onEditPressed,
                          icon: CustomIconWidget(
                            iconName: 'edit',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      userData["campus"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Verification badges
                    Row(
                      children: [
                        if (userData["studentIdVerified"] == true)
                          _buildVerificationBadge(
                            'Student ID',
                            AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        if (userData["emailVerified"] == true)
                          _buildVerificationBadge(
                            'Email',
                            AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        if (userData["phoneVerified"] == false)
                          _buildVerificationBadge(
                            'Phone',
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Bio
          if (userData["bio"] != null && (userData["bio"] as String).isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                userData["bio"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge(String label, Color color) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: color == AppTheme.lightTheme.colorScheme.tertiary
                ? 'check_circle'
                : 'radio_button_unchecked',
            color: color,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
