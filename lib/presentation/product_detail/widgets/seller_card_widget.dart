import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SellerCardWidget extends StatelessWidget {
  final Map<String, dynamic> sellerData;
  final VoidCallback onTap;

  const SellerCardWidget({
    Key? key,
    required this.sellerData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 8.w,
                          backgroundImage: NetworkImage(
                            sellerData["avatar"] as String,
                          ),
                        ),
                        if (sellerData["isVerified"] == true)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(0.5.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme
                                      .lightTheme.scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 3.w,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  sellerData["name"] as String,
                                  style:
                                      AppTheme.lightTheme.textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (sellerData["campusVerified"] == true)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Campus Verified',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  final rating = sellerData["rating"] as double;
                                  return CustomIconWidget(
                                    iconName: index < rating.floor()
                                        ? 'star'
                                        : (index < rating
                                            ? 'star_half'
                                            : 'star_border'),
                                    color: AppTheme.warningLight,
                                    size: 4.w,
                                  );
                                }),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '${sellerData["rating"]} (${sellerData["reviewCount"]} reviews)',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            sellerData["responseTime"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'chevron_right',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safety Tips',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Meet in public places on campus. Inspect items before payment.',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
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
}
