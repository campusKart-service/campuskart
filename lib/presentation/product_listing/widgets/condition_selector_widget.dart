import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConditionSelectorWidget extends StatefulWidget {
  final String selectedCondition;
  final Function(String) onConditionSelected;

  const ConditionSelectorWidget({
    super.key,
    required this.selectedCondition,
    required this.onConditionSelected,
  });

  @override
  State<ConditionSelectorWidget> createState() =>
      _ConditionSelectorWidgetState();
}

class _ConditionSelectorWidgetState extends State<ConditionSelectorWidget> {
  final List<Map<String, dynamic>> _conditions = [
    {
      "value": "New",
      "label": "New",
      "description": "Brand new, never used",
      "icon": "new_releases",
      "color": Color(0xFF10B981),
    },
    {
      "value": "Like New",
      "label": "Like New",
      "description": "Excellent condition, barely used",
      "icon": "star",
      "color": Color(0xFF059669),
    },
    {
      "value": "Good",
      "label": "Good",
      "description": "Minor wear, fully functional",
      "icon": "thumb_up",
      "color": Color(0xFFF59E0B),
    },
    {
      "value": "Fair",
      "label": "Fair",
      "description": "Noticeable wear, works well",
      "icon": "info",
      "color": Color(0xFFEF4444),
    },
  ];

  void _showConditionGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 10.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Condition Guide',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1),

              // Condition details
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(4.w),
                  itemCount: _conditions.length,
                  itemBuilder: (context, index) {
                    final condition = _conditions[index];
                    return _buildConditionGuideItem(condition);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionGuideItem(Map<String, dynamic> condition) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: (condition['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: condition['icon'],
                  color: condition['color'],
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      condition['label'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      condition['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildConditionDetails(condition['value']),
        ],
      ),
    );
  }

  Widget _buildConditionDetails(String conditionValue) {
    Map<String, List<String>> details = {
      "New": [
        "• Original packaging included",
        "• All accessories present",
        "• No signs of wear or use",
        "• Warranty still valid"
      ],
      "Like New": [
        "• Minimal to no visible wear",
        "• All functions work perfectly",
        "• May have been opened/tested",
        "• Original packaging may be missing"
      ],
      "Good": [
        "• Light scratches or scuffs",
        "• All major functions work",
        "• Normal wear from regular use",
        "• May have minor cosmetic issues"
      ],
      "Fair": [
        "• Noticeable wear and tear",
        "• All essential functions work",
        "• May have scratches or dents",
        "• Priced to reflect condition"
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What to expect:',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...details[conditionValue]!.map((detail) => Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Text(
                detail,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Select condition that best describes your item',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            GestureDetector(
              onTap: _showConditionGuide,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'help_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Guide',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Condition options
        Wrap(
          spacing: 2.w,
          runSpacing: 2.h,
          children: _conditions.map((condition) {
            final isSelected = widget.selectedCondition == condition['value'];
            return GestureDetector(
              onTap: () => widget.onConditionSelected(condition['value']),
              child: Container(
                width: (100.w - 10.w) / 2, // Two columns with spacing
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? condition['color']
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? (condition['color'] as Color).withValues(alpha: 0.05)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: (condition['color'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomIconWidget(
                            iconName: condition['icon'],
                            color: condition['color'],
                            size: 4.w,
                          ),
                        ),
                        Spacer(),
                        if (isSelected)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: condition['color'],
                            size: 5.w,
                          ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      condition['label'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? condition['color'] : null,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      condition['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
