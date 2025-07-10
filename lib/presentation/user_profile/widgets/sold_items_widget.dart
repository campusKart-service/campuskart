import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SoldItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> soldItems;
  final Function(int) onViewItem;

  const SoldItemsWidget({
    super.key,
    required this.soldItems,
    required this.onViewItem,
  });

  @override
  Widget build(BuildContext context) {
    if (soldItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: soldItems.length,
      itemBuilder: (context, index) {
        final item = soldItems[index];
        return _buildSoldItemCard(context, item);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'shopping_bag',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Sold Items',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your sold items will appear here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSoldItemCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onViewItem(item["id"] as int),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              // Item image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item["image"] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 3.w),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      item["price"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Sold on ${item["soldDate"]}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Rating and feedback
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < (item["buyerRating"] as int)
                                  ? 'star'
                                  : 'star_border',
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              size: 3.w,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            item["buyerFeedback"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
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
                      'Sold',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
