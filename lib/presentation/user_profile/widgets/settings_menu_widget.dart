import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsMenuWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onLogout;
  final VoidCallback onCampusVerification;

  const SettingsMenuWidget({
    super.key,
    required this.userData,
    required this.onLogout,
    required this.onCampusVerification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Settings',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 12.w), // Balance the close button
              ],
            ),
          ),

          // Settings content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Account section
                  _buildSectionHeader('Account'),
                  _buildSettingsItem(
                    'Account Information',
                    'personal_info',
                    () => _showAccountInfo(context),
                  ),
                  _buildSettingsItem(
                    'Campus Verification',
                    'verified_user',
                    onCampusVerification,
                    trailing: userData["isVerified"] == true
                        ? _buildVerifiedBadge()
                        : _buildPendingBadge(),
                  ),
                  _buildSettingsItem(
                    'Payment Methods',
                    'payment',
                    () => _showPaymentMethods(context),
                  ),

                  SizedBox(height: 2.h),

                  // Privacy section
                  _buildSectionHeader('Privacy & Security'),
                  _buildSettingsItem(
                    'Privacy Settings',
                    'privacy_tip',
                    () => _showPrivacySettings(context),
                  ),
                  _buildSettingsItem(
                    'Notification Preferences',
                    'notifications',
                    () => _showNotificationSettings(context),
                  ),
                  _buildSettingsItem(
                    'Blocked Users',
                    'block',
                    () => _showBlockedUsers(context),
                  ),

                  SizedBox(height: 2.h),

                  // Support section
                  _buildSectionHeader('Support'),
                  _buildSettingsItem(
                    'Help Center',
                    'help',
                    () => _showHelpCenter(context),
                  ),
                  _buildSettingsItem(
                    'Report a Problem',
                    'report_problem',
                    () => _showReportProblem(context),
                  ),
                  _buildSettingsItem(
                    'Terms of Service',
                    'description',
                    () => _showTermsOfService(context),
                  ),
                  _buildSettingsItem(
                    'Privacy Policy',
                    'policy',
                    () => _showPrivacyPolicy(context),
                  ),

                  SizedBox(height: 2.h),

                  // App section
                  _buildSectionHeader('App'),
                  _buildSettingsItem(
                    'App Version',
                    'info',
                    null,
                    trailing: Text(
                      'v1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Logout button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showLogoutConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.colorScheme.error,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'logout',
                            color: Colors.white,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Logout',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String iconName,
    VoidCallback? onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      trailing: trailing ??
          (onTap != null
              ? CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                )
              : null),
      onTap: onTap,
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            'Verified',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'pending',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            'Pending',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Account Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', userData["name"] as String),
            _buildInfoRow('Email', userData["email"] as String),
            _buildInfoRow('Campus', userData["campus"] as String),
            _buildInfoRow('Member Since', userData["memberSince"] as String),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    // Mock payment methods
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Methods'),
        content: Text('Payment methods management will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Settings'),
        content: Text('Privacy settings management will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification Preferences'),
        content: Text('Notification settings will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBlockedUsers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Blocked Users'),
        content: Text('No blocked users.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help Center'),
        content: Text('Help center will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportProblem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report a Problem'),
        content: Text('Problem reporting will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: Text('Terms of service will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: Text('Privacy policy will be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close settings
              onLogout();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
