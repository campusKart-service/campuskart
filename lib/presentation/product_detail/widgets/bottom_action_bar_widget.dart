import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomActionBarWidget extends StatelessWidget {
  final VoidCallback onMessageSeller;
  final VoidCallback onShare;
  final VoidCallback onReport;
  final VoidCallback onMakeOffer;
  final bool isNegotiable;

  const BottomActionBarWidget({
    Key? key,
    required this.onMessageSeller,
    required this.onShare,
    required this.onReport,
    required this.onMakeOffer,
    required this.isNegotiable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Secondary Actions
            Row(
              children: [
                _buildActionButton(
                  icon: 'favorite_border',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to favorites')),
                    );
                  },
                ),
                SizedBox(width: 3.w),
                _buildActionButton(
                  icon: 'share',
                  onTap: onShare,
                ),
                SizedBox(width: 3.w),
                _buildActionButton(
                  icon: 'flag',
                  onTap: onReport,
                ),
              ],
            ),
            SizedBox(width: 4.w),

            // Primary Actions
            Expanded(
              child: Row(
                children: [
                  if (isNegotiable)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onMakeOffer,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          side: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'Make Offer',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  if (isNegotiable) SizedBox(width: 3.w),
                  Expanded(
                    flex: isNegotiable ? 1 : 2,
                    child: ElevatedButton.icon(
                      onPressed: onMessageSeller,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      icon: CustomIconWidget(
                        iconName: 'message',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      label: Text(
                        'Message Seller',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ),
    );
  }
}
