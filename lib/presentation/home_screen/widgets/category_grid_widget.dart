import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryGridWidget extends StatelessWidget {
  CategoryGridWidget({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Textbooks",
      "icon": "menu_book",
      "count": 1247,
      "color": Color(0xFF6366F1),
    },
    {
      "name": "Electronics",
      "icon": "devices",
      "count": 892,
      "color": Color(0xFF8B5CF6),
    },
    {
      "name": "Furniture",
      "icon": "chair",
      "count": 634,
      "color": Color(0xFF06B6D4),
    },
    {
      "name": "Clothing",
      "icon": "checkroom",
      "count": 521,
      "color": Color(0xFFEC4899),
    },
    {
      "name": "Sports",
      "icon": "sports_basketball",
      "count": 387,
      "color": Color(0xFF10B981),
    },
    {
      "name": "Lab Equipment",
      "icon": "science",
      "count": 298,
      "color": Color(0xFFF59E0B),
    },
    {
      "name": "Art Supplies",
      "icon": "palette",
      "count": 245,
      "color": Color(0xFFEF4444),
    },
    {
      "name": "More",
      "icon": "more_horiz",
      "count": 156,
      "color": Color(0xFF6B7280),
    },
  ];

  void _onCategoryTap(BuildContext context, Map<String, dynamic> category) {
    HapticFeedback.lightImpact();
    // Navigate to category-specific listings
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Shop by Category",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(context, category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => _onCategoryTap(context, category),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: (category["color"] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: category["icon"] as String,
                  color: category["color"] as Color,
                  size: 24,
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Category name
            Text(
              category["name"] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 0.5.h),

            // Item count
            Text(
              "${category["count"]} items",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 9.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
